# Outputs expose the key information after Terraform applies the configuration.
output "windows_vm_names" {
  description = "Names of the Windows VMs, keyed by VM key."
  value       = { for k, m in module.windows_vm : k => m.vm_name }
}

output "windows_ip_addresses" {
  description = "Primary IP address assigned to each Windows VM."
  value       = { for k, m in module.windows_vm : k => m.ip_address }
}

output "windows_mac_addresses" {
  description = "Primary MAC address of each Windows VM."
  value       = { for k, m in module.windows_vm : k => m.mac_address }
}

output "windows_disk_paths" {
  description = "Path to each Windows VM disk image."
  value       = { for k, m in module.windows_vm : k => m.disk_path }
}

output "windows_uuids" {
  description = "UUID of each Windows VM."
  value       = { for k, m in module.windows_vm : k => m.uuid }
}

# output "linux_vm_name" {
#   description = "Name of the Linux VM."
#   value       = module.linux_vm.vm_name
# }

# output "linux_ip_address" {
#   description = "Primary IP address assigned to the Linux VM."
#   value       = module.linux_vm.ip_address
# }

# output "linux_mac_address" {
#   description = "Primary MAC address of the Linux VM."
#   value       = module.linux_vm.mac_address
# }

# output "linux_disk_path" {
#   description = "Path to the Linux VM disk image."
#   value       = module.linux_vm.disk_path
# }

# output "linux_uuid" {
#   description = "UUID of the Linux VM."
#   value       = module.linux_vm.uuid
# }
