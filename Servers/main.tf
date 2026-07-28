# This root module composes the lab by instantiating reusable modules.
# The architecture is intentionally modular so networking and storage can evolve independently.
locals {
  common_network_mode = var.network_mode
  common_network_name = var.network_name
  common_bridge_name  = var.bridge_name

  # Build static DHCP reservations from any Windows VM that pins both a MAC and IP.
  windows_dhcp_reservations = [
    for name, cfg in var.windows_vms : {
      hostname = coalesce(cfg.hostname, name)
      mac      = cfg.mac_address
      ip       = cfg.ip_address
    } if cfg.mac_address != "" && cfg.ip_address != ""
  ]
}

module "network" {
  source = "./modules/network"

  network_mode      = local.common_network_mode
  network_name      = local.common_network_name
  network_cidr      = var.network_cidr
  bridge_name       = local.common_bridge_name
  dhcp_reservations = local.windows_dhcp_reservations
}

module "windows_vm" {
  source   = "./modules/windows-vm"
  for_each = var.windows_vms

  vm_name           = each.key
  memory_mb         = each.value.memory_mb
  vcpus             = each.value.vcpus
  disk_size_gb      = each.value.disk_size_gb
  disk_pool         = var.windows_disk_pool
  iso_path          = var.windows_iso_path
  extra_iso_paths   = var.windows_extra_iso_paths
  network_mode      = var.windows_network_mode
  network_name      = var.windows_network_name
  bridge_name       = var.windows_bridge_name
  hostname             = coalesce(each.value.hostname, each.key)
  timezone             = var.windows_timezone
  username             = var.windows_username
  password             = var.windows_password
  windows_edition      = var.windows_edition
  locale               = var.windows_locale
  attach_install_media = each.value.attach_install_media
  mac_address          = each.value.mac_address
  firmware_path        = var.windows_firmware_path
  base_image_path   = module.storage.windows_disk_paths[each.key]
  network_interface = module.network.primary_network_name
  depends_on        = [module.network]
}

# module "linux_vm" {
#   source = "./modules/linux-vm"

#   vm_name           = var.linux_vm_name
#   memory_mb         = var.linux_memory_mb
#   vcpus             = var.linux_vcpus
#   disk_size_gb      = var.linux_disk_size_gb
#   disk_pool         = var.linux_disk_pool
#   network_mode      = var.linux_network_mode
#   network_name      = var.linux_network_name
#   bridge_name       = var.linux_bridge_name
#   hostname          = var.linux_hostname
#   timezone          = var.linux_timezone
#   username          = var.linux_username
#   password          = var.linux_password
#   firmware_path     = var.linux_firmware_path
#   base_image_path   = module.storage.linux_disk_path
#   network_interface = module.network.primary_network_name
#   depends_on        = [module.network]
# }

module "storage" {
  source = "./modules/storage"

  windows_disk_pool  = var.windows_disk_pool
  windows_disks      = { for name, cfg in var.windows_vms : name => { size_gb = cfg.disk_size_gb } }
  linux_disk_pool    = var.linux_disk_pool
  linux_disk_size_gb = var.linux_disk_size_gb
}
