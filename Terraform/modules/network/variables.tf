# Network variables make the lab portable across host environments.
variable "network_mode" {
  description = "The preferred networking mode for the lab. Supported values are nat and bridge."
  type        = string
  default     = "nat"
}

variable "network_name" {
  description = "Name of the libvirt NAT network to use when network_mode is nat."
  type        = string
  default     = "default"
}

variable "network_cidr" {
  description = "IPv4 CIDR for the lab NAT network. Must not overlap libvirt's default 192.168.122.0/24."
  type        = string
  default     = "192.168.150.0/24"
}

variable "bridge_name" {
  description = "Bridge interface name to use when network_mode is bridge."
  type        = string
  default     = ""
}
