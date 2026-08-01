# This module creates the Windows Server 2022 guest.
# The VM uses UEFI, Q35, host-passthrough CPU, and a fully unattended install
# driven by an autounattend.xml answer file delivered on a small generated ISO.
locals {
  # All generated artifacts for this VM live under a per-VM build directory.
  build_dir        = "${path.module}/build/${var.vm_name}"
  answer_src_dir   = "${local.build_dir}/src"
  answer_file      = "${local.answer_src_dir}/autounattend.xml"
  autounattend_iso = abspath("${local.build_dir}/autounattend.iso")
}

# Render the answer file from the template using the per-VM settings.
# Only generated while install media is attached (a fresh, uninstalled VM).
resource "local_file" "autounattend" {
  count = var.attach_install_media ? 1 : 0

  filename             = local.answer_file
  file_permission      = "0644"
  directory_permission = "0755"

  content = templatefile("${path.module}/templates/autounattend.xml.tftpl", {
    computer_name  = var.hostname
    username       = var.username
    admin_password = var.password
    timezone       = var.timezone
    edition        = var.windows_edition
    locale         = var.locale
  })
}

# Build a small ISO that carries autounattend.xml at its root. Windows Setup
# automatically searches attached media for this file. xorriso is used because
# genisoimage/mkisofs are not installed on this host.
resource "null_resource" "autounattend_iso" {
  count = var.attach_install_media ? 1 : 0

  triggers = {
    answer_hash = local_file.autounattend[0].content_sha256
    iso_path    = local.autounattend_iso
    src_dir     = local.answer_src_dir
  }

  provisioner "local-exec" {
    command = "xorriso -as mkisofs -R -J -V AUTOUNATTEND -o '${local.autounattend_iso}' '${local.answer_src_dir}'"
  }

  provisioner "local-exec" {
    when       = destroy
    command    = "rm -f '${self.triggers.iso_path}'"
    on_failure = continue
  }
}

resource "libvirt_domain" "windows_vm" {
  name      = var.vm_name
  memory    = var.memory_mb
  vcpu      = var.vcpus
  machine   = "q35"
  autostart = false

  # The answer-file ISO must exist before the domain boots the installer.
  depends_on = [null_resource.autounattend_iso]

  cpu {
    mode = "host-passthrough"
  }

  firmware = var.firmware_path

  # Default (virtio) boot disk; the XSLT below rewrites it onto the SATA bus so
  # the Windows installer can see it without extra drivers.
  disk {
    volume_id = var.base_image_path
  }

  network_interface {
    network_name   = var.network_interface
    mac            = var.mac_address != "" ? var.mac_address : null
    wait_for_lease = false
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  # Rendered XSLT injects <features>, moves the boot disk to SATA, swaps the NIC
  # to an emulated Intel e1000e (Windows has no inbox virtio-net driver), and
  # attaches the install/answer DVDs with boot order only when installing.
  xml {
    xslt = templatefile("${path.module}/templates/domain.xsl.tftpl", {
      windows_iso          = var.iso_path
      autounattend_iso     = local.autounattend_iso
      attach_install_media = var.attach_install_media
      vcpus                = var.vcpus
    })
  }

  lifecycle {
    # The XSLT above injects two CD-ROM devices (Windows install DVD +
    # autounattend answer-file DVD) that the libvirt provider reads back into
    # state as extra `disk` blocks not present in this config. Without this,
    # every plan would see that drift and force a destroy/recreate of the
    # domain. Ignoring `disk` keeps the XSLT-managed devices stable.
    ignore_changes = [disk]
  }
}
