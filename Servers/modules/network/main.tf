# This module manages the libvirt network layer.
# A default NAT network is used first because it is the safest, most portable option.
# The design keeps the interface compatible with a future switch to bridge networking.
resource "libvirt_network" "nat_network" {
  count = var.network_mode == "nat" ? 1 : 0

  name      = var.network_name
  mode      = "nat"
  addresses = [var.network_cidr]
  autostart = true

  dhcp {
    enabled = true
  }

  dns {
    enabled = true
  }

  # Inject static DHCP reservations (fixed IP per MAC) when any are defined.
  dynamic "xml" {
    for_each = length(var.dhcp_reservations) > 0 ? [1] : []
    content {
      xslt = templatefile("${path.module}/templates/network.xsl.tftpl", {
        reservations = var.dhcp_reservations
      })
    }
  }
}

resource "libvirt_network" "bridge_network" {
  count = var.network_mode == "bridge" ? 1 : 0

  name      = var.network_name
  mode      = "bridge"
  bridge    = var.bridge_name
  addresses = []
  autostart = true
}
