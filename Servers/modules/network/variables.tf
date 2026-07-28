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

variable "dhcp_reservations" {
  description = "Static DHCP reservations injected into the NAT network's <dhcp> block. Each binds a fixed IP to a MAC so the guest always gets the same address."
  type = list(object({
    hostname = string
    mac      = string
    ip       = string
  }))
  default = []
}

variable "dns_server_ip" {
  description = "If set, advertise this IP to all NAT guests as their DNS server via DHCP option 6 (using libvirt's dnsmasq namespace). Point this at the AD DS domain controller so domain members resolve the AD domain. Empty = keep libvirt's built-in DNS at the gateway (.1)."
  type        = string
  default     = ""
}
