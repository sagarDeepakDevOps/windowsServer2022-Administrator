# Storage variables define the volume names and sizes for the lab images.
# QCOW2 is used because it is the native thin-provisioned image format for KVM/QEMU.
variable "windows_disks" {
  description = "Map of Windows disks to create, keyed by VM name. Each value defines the disk size in GB."
  type = map(object({
    size_gb = number
  }))
  default = {}
}

variable "windows_disk_pool" {
  description = "Libvirt storage pool for the Windows volume."
  type        = string
  default     = "default"
}

variable "linux_disk_name" {
  description = "Name of the Linux QCOW2 volume."
  type        = string
  default     = "linux-system.qcow2"
}

variable "linux_disk_pool" {
  description = "Libvirt storage pool for the Linux volume."
  type        = string
  default     = "default"
}

variable "linux_disk_size_gb" {
  description = "Size of the Linux volume in gigabytes."
  type        = number
  default     = 40
}
