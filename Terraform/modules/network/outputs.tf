# Outputs expose the network selection so the VM modules can attach to it.
output "primary_network_name" {
  description = "The effective libvirt network name that the VMs should attach to."
  value       = var.network_mode == "nat" ? var.network_name : var.network_name
}
