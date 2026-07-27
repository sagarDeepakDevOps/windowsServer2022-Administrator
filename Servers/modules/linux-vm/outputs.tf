# Outputs expose the key Ubuntu guest details for operators.
output "vm_name" {
  description = "Name of the Ubuntu VM."
  value       = libvirt_domain.linux_vm.name
}

output "ip_address" {
  description = "Primary IP address of the Ubuntu VM."
  value       = libvirt_domain.linux_vm.network_interface[0].addresses[0]
}

output "mac_address" {
  description = "Primary MAC address of the Ubuntu VM."
  value       = libvirt_domain.linux_vm.network_interface[0].mac
}

output "disk_path" {
  description = "Path to the Ubuntu disk image."
  value       = var.base_image_path
}

output "uuid" {
  description = "UUID of the Ubuntu VM."
  value       = libvirt_domain.linux_vm.id
}
