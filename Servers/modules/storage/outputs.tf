# Outputs allow the parent module to consume the created disk resources.
output "windows_disk_paths" {
  description = "Map of VM name to Windows QCOW2 disk image path."
  value       = { for k, v in libvirt_volume.windows_disk : k => v.id }
}

output "linux_disk_path" {
  description = "Path to the Linux QCOW2 disk image."
  value       = libvirt_volume.linux_disk.id
}
