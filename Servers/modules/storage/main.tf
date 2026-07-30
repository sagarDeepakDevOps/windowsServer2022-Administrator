# This module creates the QCOW2 boot disks for the VMs.
# QCOW2 is selected because it is the standard sparse image format for KVM/QEMU,
# supports thin provisioning, and keeps capacity overhead low while remaining portable.
#
# NOTE: the storage pool (default: "default") is expected to already exist in
# libvirt (it ships as a built-in pool). We reference it by name rather than
# managing it as a resource, because creating a pool that already exists errors,
# and importing it crashes the dmacvicar/libvirt provider.

resource "libvirt_volume" "windows_disk" {
  for_each = var.windows_disks

  name             = "windows-${each.key}.qcow2"
  pool             = var.windows_disk_pool
  format           = "qcow2"
  size             = each.value.size_gb * 1024 * 1024 * 1024
  base_volume_name = null
}

resource "libvirt_volume" "linux_disk" {
  name             = var.linux_disk_name
  pool             = var.linux_disk_pool
  format           = "qcow2"
  size             = var.linux_disk_size_gb * 1024 * 1024 * 1024
  base_volume_name = null
}
