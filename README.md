# windowsServer2022-Administrator

Infrastructure-as-Code for my Windows Server 2022 lab on KVM/libvirt, managed with Terraform.

## What's inside

- `Terraform/` — Terraform code that provisions Windows Server 2022 (and optional
  Ubuntu) VMs on a local KVM/libvirt host, using the `dmacvicar/libvirt` provider.
- `Github/` — Terraform code (this folder) that manages this GitHub repository itself.

## Highlights

- Multiple Windows VMs via a `windows_vms` map and `for_each`.
- Dedicated NAT network and libvirt storage pool.
- UEFI (OVMF) firmware, VirtIO devices, host-passthrough CPU.

> Managed with Terraform. Do not edit repository settings by hand — change the
> code in `Github/` and run `terraform apply`.
