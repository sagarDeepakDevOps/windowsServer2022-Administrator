# This configuration provisions and manages a GitHub repository entirely with
# Terraform, so every setting you would normally click in the GitHub UI is
# expressed as code. This is a great way to learn what a repository is made of.

# The repository itself: visibility, features, merge behavior, and initial seed
# files (README, .gitignore, LICENSE) are all managed declaratively.
resource "github_repository" "repo" {
  name        = var.repository_name
  description = var.repository_description
  visibility  = var.visibility

  # auto_init creates the first commit so a default branch exists immediately.
  # gitignore/license templates seed those files from GitHub's template library.
  auto_init          = true
  gitignore_template = var.gitignore_template != "" ? var.gitignore_template : null
  license_template   = var.license_template != "" ? var.license_template : null

  # Feature tabs.
  has_issues   = var.has_issues
  has_wiki     = var.has_wiki
  has_projects = var.has_projects

  # Pull request / merge behavior.
  allow_merge_commit     = true
  allow_squash_merge     = true
  allow_rebase_merge     = true
  delete_branch_on_merge = var.delete_branch_on_merge

  topics = var.topics
}

# Explicitly manage which branch is the default.
resource "github_branch_default" "default" {
  repository = github_repository.repo.name
  branch     = var.default_branch
}

# Manage the README content as code. overwrite_on_create replaces the README
# that auto_init generated so Terraform becomes the source of truth for it.
resource "github_repository_file" "readme" {
  repository          = github_repository.repo.name
  branch              = github_branch_default.default.branch
  file                = "README.md"
  commit_message      = "docs: manage README via Terraform"
  overwrite_on_create = true

  content = <<-EOT
    # ${var.repository_name}

    ${var.repository_description}

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
  EOT
}

# Manage issue labels as code.
resource "github_issue_label" "labels" {
  for_each = var.labels

  repository = github_repository.repo.name
  name       = each.key
  color      = each.value
}

# Optional protection for the default branch. Disabled by default so you can push
# directly while learning. Set enable_branch_protection = true to require PRs.
resource "github_branch_protection" "default" {
  count = var.enable_branch_protection ? 1 : 0

  repository_id  = github_repository.repo.node_id
  pattern        = var.default_branch
  enforce_admins = true

  required_pull_request_reviews {
    required_approving_review_count = 1
  }
}
