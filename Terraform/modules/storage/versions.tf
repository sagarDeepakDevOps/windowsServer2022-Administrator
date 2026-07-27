# This module declares the provider source explicitly so Terraform resolves the libvirt provider correctly.
terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}
