# Outputs expose the key Windows guest details for operators.
output "vm_name" {
  description = "Name of the Windows VM."
  value       = libvirt_domain.windows_vm.name
}

output "ip_address" {
  description = "Primary IP address of the Windows VM."
  value       = try(libvirt_domain.windows_vm.network_interface[0].addresses[0], null)
}

output "mac_address" {
  description = "Primary MAC address of the Windows VM."
  value       = try(libvirt_domain.windows_vm.network_interface[0].mac, null)
}

output "disk_path" {
  description = "Path to the Windows disk image."
  value       = var.base_image_path
}

output "uuid" {
  description = "UUID of the Windows VM."
  value       = libvirt_domain.windows_vm.id
}
