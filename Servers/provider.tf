# This file configures the libvirt provider for the local QEMU/KVM host.
# The provider is the bridge between Terraform and the system libvirt daemon.
provider "libvirt" {
  uri = "qemu:///system"
}
