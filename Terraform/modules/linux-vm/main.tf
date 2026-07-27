# This module creates the Ubuntu Server guest and includes cloud-init support.
# Cloud-init is used to make the image configurable and automation-friendly,
# which is important for future Ansible and Packer integrations.
resource "libvirt_domain" "linux_vm" {
  name      = var.vm_name
  memory    = var.memory_mb
  vcpu      = var.vcpus
  machine   = "q35"
  autostart = false

  cpu {
    mode = "host-passthrough"
  }

  firmware = var.firmware_path

  disk {
    volume_id = var.base_image_path
    scsi      = true
  }

  network_interface {
    network_name   = var.network_interface
    wait_for_lease = true
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

  xml {
    xslt = <<-EOT
      <xsl:stylesheet version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <xsl:output omit-xml-declaration="yes"/>
        <xsl:template match="/">
          <xsl:apply-templates select="node()"/>
        </xsl:template>
        <xsl:template match="devices">
          <features>
            <acpi/>
            <apic/>
          </features>
          <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
          </xsl:copy>
        </xsl:template>
        <xsl:template match="@*|node()">
          <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
          </xsl:copy>
        </xsl:template>
      </xsl:stylesheet>
    EOT
  }

  cloudinit = libvirt_cloudinit_disk.commoninit.id
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "${var.vm_name}-cloudinit.iso"
  pool      = var.disk_pool
  user_data = <<-EOT
    #cloud-config
    hostname: ${var.hostname}
    manage_etc_hosts: true
    timezone: ${var.timezone}
    users:
      - name: ${var.username}
        sudo: ALL=(ALL) NOPASSWD:ALL
        shell: /bin/bash
        lock_passwd: false
        plain_text_passwd: ${var.password}
    package_update: true
    package_upgrade: false
    packages:
      - qemu-guest-agent
    runcmd:
      - systemctl enable qemu-guest-agent
      - systemctl start qemu-guest-agent
  EOT

  network_config = <<-EOT
    version: 2
    ethernets:
      ens3:
        dhcp4: true
  EOT
}
