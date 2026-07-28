# Windows VM inputs keep the module reusable for other lab environments.
variable "vm_name" {
  description = "Name of the Windows VM."
  type        = string
}

variable "memory_mb" {
  description = "Memory in megabytes for the Windows VM."
  type        = number
}

variable "vcpus" {
  description = "Number of vCPUs for the Windows VM."
  type        = number
}

variable "disk_size_gb" {
  description = "Size of the main Windows disk in gigabytes."
  type        = number
}

variable "iso_path" {
  description = "Path to the installation ISO for Windows Server."
  type        = string
}

variable "hostname" {
  description = "Hostname of the Windows VM."
  type        = string
}

variable "timezone" {
  description = "Timezone for the Windows VM."
  type        = string
}

variable "username" {
  description = "Administrative username to configure at install time."
  type        = string
}

variable "password" {
  description = "Administrative password for the Windows VM."
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

variable "windows_edition" {
  description = "Windows image name to install (must match an image in the ISO, e.g. the value shown by DISM /Get-WimInfo). Used by the autounattend answer file."
  type        = string
}

variable "locale" {
  description = "Locale/language used during unattended Windows Setup (e.g. en-US)."
  type        = string
  default     = "en-US"
}

variable "attach_install_media" {
  description = "Attach the Windows install DVD + autounattend answer-file DVD and boot from them. Set true for a fresh (uninstalled) VM; set false once Windows is installed so the VM boots straight from disk."
  type        = bool
  default     = true
}

variable "mac_address" {
  description = "Fixed MAC address for the primary NIC. Empty lets libvirt generate one (which yields a different DHCP IP on every recreate)."
  type        = string
  default     = ""
}
