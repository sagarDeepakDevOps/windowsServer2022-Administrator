# This module creates the QCOW2 boot disks for the VMs.
# QCOW2 is selected because it is the standard sparse image format for KVM/QEMU,
# supports thin provisioning, and keeps capacity overhead low while remaining portable.
resource "libvirt_pool" "storage_pool" {
  name = var.windows_disk_pool
  type = "dir"

  target {
    path = "/var/lib/libvirt/images"
  }
}

resource "libvirt_volume" "windows_disk" {
  for_each = var.windows_disks

  name             = "windows-${each.key}.qcow2"
  pool             = libvirt_pool.storage_pool.name
  format           = "qcow2"
  size             = each.value.size_gb * 1024 * 1024 * 1024
  base_volume_name = null
}

resource "libvirt_volume" "linux_disk" {
  name             = var.linux_disk_name
  pool             = libvirt_pool.storage_pool.name
  format           = "qcow2"
  size             = var.linux_disk_size_gb * 1024 * 1024 * 1024
  base_volume_name = null
}
