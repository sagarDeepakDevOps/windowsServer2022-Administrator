# Terraform version and provider constraints keep the project reproducible.
# Pinning the provider version reduces drift when the libvirt provider evolves.
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.8.0"
    }
  }
}