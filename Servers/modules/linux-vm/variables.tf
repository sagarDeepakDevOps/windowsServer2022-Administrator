# Linux VM inputs keep the module reusable for other Ubuntu-based lab workloads.
variable "vm_name" {
  description = "Name of the Ubuntu VM."
  type        = string
}

variable "memory_mb" {
  description = "Memory in megabytes for the Ubuntu VM."
  type        = number
}

variable "vcpus" {
  description = "Number of vCPUs for the Ubuntu VM."
  type        = number
}

variable "disk_size_gb" {
  description = "Size of the Ubuntu disk in gigabytes."
  type        = number
}

variable "disk_pool" {
  description = "Storage pool used for the Ubuntu disk."
  type        = string
}

variable "network_mode" {
  description = "Networking mode for the VM."
  type        = string
  default     = "nat"
}

variable "network_name" {
  description = "Name of the libvirt network to attach when using NAT."
  type        = string
  default     = "default"
}

variable "bridge_name" {
  description = "Bridge device name used for bridge networking later."
  type        = string
  default     = ""
}

variable "hostname" {
  description = "Hostname of the Ubuntu VM."
  type        = string
}

variable "timezone" {
  description = "Timezone for the Ubuntu VM."
  type        = string
}

variable "username" {
  description = "Username to create in cloud-init."
  type        = string
}

variable "password" {
  description = "Password to configure in cloud-init."
  type        = string
  sensitive   = true
}

variable "firmware_path" {
  description = "UEFI firmware image used by the VM."
  type        = string
}

variable "base_image_path" {
  description = "Path to the base QCOW2 disk image that the VM should use."
  type        = string
}

variable "network_interface" {
  description = "Name of the libvirt network that should be attached."
  type        = string
}
