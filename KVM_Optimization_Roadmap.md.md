# Windows Server KVM Lab Optimization Roadmap

## Objective

This roadmap defines the optimization strategy for my Terraform-based KVM infrastructure.

The goal is NOT to build an enterprise datacenter.

The goal is to create a stable, high-performance, production-style Windows Server learning lab that will be used for:

- Windows Server 2022
- Active Directory
- DNS
- DHCP
- Group Policy
- File Server
- IIS
- PowerShell
- WSUS
- Windows Administration

The roadmap prioritizes:

- Stability
- Simplicity
- Maintainability
- Best Practices

over unnecessary enterprise optimizations.

---

# Global Rules

Before making any changes:

- Do NOT rewrite the project.
- Do NOT change the folder structure.
- Do NOT remove modules.
- Preserve existing functionality.
- Keep Terraform modular.
- Explain every change before implementing it.
- Modify only the files required.
- Complete one phase at a time.
- Stop after each phase and wait for confirmation.

After every phase execute:

terraform fmt

terraform validate

terraform plan

terraform apply

Commit changes to Git before moving to the next phase.

---

# PHASE 1
## VM Experience & Guest Integration

Goal:

Make Windows behave similarly to VMware Workstation.

Review and improve:

- Replace PS/2 Mouse with USB Tablet
- Replace Cirrus Video with QXL (or Virtio GPU if appropriate)
- Verify SPICE Display
- Add SPICE vdagent communication channel
- Verify QEMU Guest Agent channel
- Ensure clipboard integration works
- Ensure automatic display resizing works


---

# PHASE 2
## Windows Performance

Goal:

Improve Windows performance while keeping the project simple.

Review only:

- CPU topology
- CPU mode
- Host Passthrough
- Recommended Hyper-V enlightenments
- Memory Balloon configuration

Do NOT implement:

- NUMA
- Huge Pages
- CPU Pinning
- Advanced Timer tuning
- APIC tuning

---

# PHASE 3
## Storage Optimization

Goal:

Improve Windows storage performance.

Review:

- QCOW2
- Disk Bus
- SATA vs VirtIO
- Cache Mode
- TRIM / Discard


---

# PHASE 4
## Networking

Goal:

Optimize networking while keeping the lab simple.

Review:

- e1000e vs VirtIO
- DHCP Reservations
- DNS Configuration
- NAT configuration

Do NOT implement:

- VLANs
- Bridged Networking
- SR-IOV
- MTU tuning
- Multi Queue
- Offloading


---

# PHASE 5
## Terraform Cleanup

Goal:


---

# Out of Scope

The following features are intentionally excluded because this project focuses on Windows Server learning rather than enterprise virtualization:

- NUMA
- Huge Pages
- CPU Pinning
- PCI Passthrough
- SR-IOV
- Secure Boot
- TPM 2.0
- SMBIOS tuning
- ACPI tuning
- OpenGL optimization
- Multi-monitor optimization
- VLANs
- Linked Clones
- Golden Images
- Snapshot Strategy
- Enterprise Scaling
- High Availability
- Live Migration
- Ceph Storage
- Fibre Channel
- SAN
- Multipath
- OpenStack Integration

These topics can be implemented later in a separate "Advanced KVM Masterclass".

---

# Final Goal

The final Terraform project should create a reusable Windows Server learning lab capable of provisioning:

- Windows Server 2022 Domain Controller
- Windows Server Member Server

using a single command:

terraform apply

The resulting lab should provide a smooth user experience, good Windows performance, clean Terraform code, and a solid foundation for learning Windows Server administration, Active Directory, DevOps, and Hybrid Cloud technologies.POPmcp