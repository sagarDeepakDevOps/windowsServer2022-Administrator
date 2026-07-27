# Root variables define the deployment inputs for both the Windows and Linux VMs.
# Keeping them here makes the module interface explicit and reusable.
variable "windows_vms" {
  description = "Map of Windows Server VMs to create. The map key is used as the VM/domain name and must be unique."
  type = map(object({
    memory_mb    = optional(number, 2048)
    vcpus        = optional(number, 2)
    disk_size_gb = optional(number, 40)
    hostname     = optional(string)
  }))
  default = {
    "AD-DS-vm" = {
      memory_mb    = 2048
      vcpus        = 2
      disk_size_gb = 20
      hostname     = "AD-DS-vm"
    }
  }

  validation {
    condition     = alltrue([for v in values(var.windows_vms) : v.memory_mb >= 1024])
    error_message = "Each Windows VM memory_mb must be at least 1024 MB."
  }

  validation {
    condition     = alltrue([for v in values(var.windows_vms) : v.vcpus >= 1 && v.vcpus <= 16])
    error_message = "Each Windows VM vcpus must be between 1 and 16."
  }

  validation {
    condition     = alltrue([for v in values(var.windows_vms) : v.disk_size_gb >= 10])
    error_message = "Each Windows VM disk_size_gb must be at least 10 GB."
  }
}

variable "windows_disk_pool" {
  description = "Name of the libvirt storage pool used for the Windows disk."
  type        = string
  default     = "default"
}

variable "windows_iso_path" {
  description = "Path to the Windows installation ISO image."
  type        = string
  default     = "/home/deepak/Downloads/SERVER_EVAL_x64FRE_en-us.iso"
}

variable "windows_extra_iso_paths" {
  description = "Optional additional ISO files to attach to the Windows VM."
  type        = list(string)
  default     = []
}

variable "windows_network_mode" {
  description = "Networking mode for the Windows VM. Use nat initially or bridge later."
  type        = string
  default     = "nat"

  validation {
    condition     = contains(["nat", "bridge"], var.windows_network_mode)
    error_message = "windows_network_mode must be either nat or bridge."
  }
}

variable "windows_network_name" {
  description = "Name of the libvirt network to use for the Windows VM when nat mode is selected."
  type        = string
  default     = "default"
}

variable "windows_bridge_name" {
  description = "Bridge device name used for bridge networking when Windows is moved off NAT."
  type        = string
  default     = ""
}

variable "windows_timezone" {
  description = "Timezone configured for the Windows guest."
  type        = string
  default     = "UTC"
}

variable "windows_username" {
  description = "Administrative username for the Windows guest."
  type        = string
  default     = "Administrator"
}

variable "windows_password" {
  description = "Administrative password for the Windows guest. Set via terraform.auto.tfvars (git-ignored) or the TF_VAR_windows_password environment variable. No default so secrets are never committed."
  type        = string
  sensitive   = true
}

variable "windows_firmware_path" {
  description = "UEFI firmware image used by the Windows VM."
  type        = string
  default     = "/usr/share/OVMF/OVMF_CODE_4M.fd"
}

variable "windows_edition" {
  description = "Windows image name to install unattended. Must match an image name in the ISO. For the Server 2022 eval ISO the Standard GUI image is 'Windows Server 2022 Standard Evaluation (Desktop Experience)'."
  type        = string
  default     = "Windows Server 2022 Standard Evaluation (Desktop Experience)"
}

variable "windows_locale" {
  description = "Locale/language used during unattended Windows Setup."
  type        = string
  default     = "en-US"
}

variable "linux_vm_name" {
  description = "Name of the Ubuntu Server VM."
  type        = string
  default     = "ubuntu24-lab"
}

variable "linux_memory_mb" {
  description = "Memory allocated to the Linux VM in megabytes."
  type        = number
  default     = 4096

  validation {
    condition     = var.linux_memory_mb >= 1024
    error_message = "linux_memory_mb must be at least 1024 MB."
  }
}

variable "linux_vcpus" {
  description = "Number of vCPUs allocated to the Linux VM."
  type        = number
  default     = 2

  validation {
    condition     = var.linux_vcpus >= 1 && var.linux_vcpus <= 16
    error_message = "linux_vcpus must be between 1 and 16."
  }
}

variable "linux_disk_size_gb" {
  description = "Size of the Linux boot disk in gigabytes."
  type        = number
  default     = 40

  validation {
    condition     = var.linux_disk_size_gb >= 20
    error_message = "linux_disk_size_gb must be at least 20 GB."
  }
}

variable "linux_disk_pool" {
  description = "Name of the libvirt storage pool used for the Linux disk."
  type        = string
  default     = "default"
}

variable "linux_network_mode" {
  description = "Networking mode for the Linux VM. Use nat initially or bridge later."
  type        = string
  default     = "nat"

  validation {
    condition     = contains(["nat", "bridge"], var.linux_network_mode)
    error_message = "linux_network_mode must be either nat or bridge."
  }
}

variable "linux_network_name" {
  description = "Name of the libvirt network to use for the Linux VM when nat mode is selected."
  type        = string
  default     = "default"
}

variable "linux_bridge_name" {
  description = "Bridge device name used for bridge networking when Linux is moved off NAT."
  type        = string
  default     = ""
}

variable "linux_hostname" {
  description = "Hostname for the Ubuntu guest."
  type        = string
  default     = "ubuntu24-lab"
}

variable "linux_timezone" {
  description = "Timezone configured for the Ubuntu guest."
  type        = string
  default     = "UTC"
}

variable "linux_username" {
  description = "Username for the Ubuntu guest user created by cloud-init."
  type        = string
  default     = "ubuntu"
}

variable "linux_password" {
  description = "Password for the Ubuntu guest user created by cloud-init. Set via terraform.auto.tfvars (git-ignored) or the TF_VAR_linux_password environment variable. No default so secrets are never committed."
  type        = string
  sensitive   = true
}

variable "linux_firmware_path" {
  description = "UEFI firmware image used by the Linux VM."
  type        = string
  default     = "/usr/share/OVMF/OVMF_CODE_4M.fd"
}

variable "network_mode" {
  description = "Shared network mode for the lab. Defaults to NAT and can later be switched to bridge."
  type        = string
  default     = "nat"

  validation {
    condition     = contains(["nat", "bridge"], var.network_mode)
    error_message = "network_mode must be either nat or bridge."
  }
}

variable "network_name" {
  description = "Name of the libvirt network to use when NAT is selected."
  type        = string
  default     = "default"
}

variable "network_cidr" {
  description = "IPv4 CIDR for the lab NAT network. Must not overlap libvirt's default 192.168.122.0/24."
  type        = string
  default     = "192.168.150.0/24"
}

variable "bridge_name" {
  description = "Bridge device to use when the lab is switched to bridge networking."
  type        = string
  default     = ""
}
