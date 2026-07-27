# This module creates the Windows Server 2022 guest.
# The VM uses UEFI, Q35, VirtIO devices, and host-passthrough CPU settings
# to align with modern Linux/KVM performance and compatibility expectations.
resource "libvirt_domain" "windows_vm" {
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
            <hyperv/>
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
}
