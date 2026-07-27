# Inputs for the GitHub repository. Keeping them as variables makes the
# configuration reusable for future repositories in your Windows Server journey.

variable "github_owner" {
  description = "GitHub user or organization that will own the repository."
  type        = string
  default     = "sagarDeepakDevOps"
}

variable "repository_name" {
  description = "Name of the GitHub repository to create."
  type        = string
  default     = "windows-server-2022-lab"
}

variable "repository_description" {
  description = "Short description shown at the top of the repository."
  type        = string
  default     = "Infrastructure-as-Code for my Windows Server 2022 lab on KVM/libvirt, managed with Terraform."
}

variable "visibility" {
  description = "Repository visibility. One of public, private, or internal."
  type        = string
  default     = "public"

  validation {
    condition     = contains(["public", "private", "internal"], var.visibility)
    error_message = "visibility must be one of public, private, or internal."
  }
}

variable "default_branch" {
  description = "Name of the default branch."
  type        = string
  default     = "main"
}

variable "gitignore_template" {
  description = "GitHub .gitignore template name to seed the repo with (e.g. Terraform). Empty string disables it."
  type        = string
  default     = "Terraform"
}

variable "license_template" {
  description = "GitHub license template name (e.g. mit, apache-2.0). Empty string disables it."
  type        = string
  default     = "mit"
}

variable "topics" {
  description = "Repository topics used for discoverability."
  type        = list(string)
  default     = ["terraform", "libvirt", "kvm", "windows-server", "iac", "homelab"]
}

variable "has_issues" {
  description = "Enable the Issues tab."
  type        = bool
  default     = true
}

variable "has_wiki" {
  description = "Enable the Wiki tab."
  type        = bool
  default     = false
}

variable "has_projects" {
  description = "Enable the Projects tab."
  type        = bool
  default     = false
}

variable "delete_branch_on_merge" {
  description = "Automatically delete head branches after pull requests are merged."
  type        = bool
  default     = true
}

variable "enable_branch_protection" {
  description = "Protect the default branch. NOTE: when true, direct pushes to the default branch may be restricted and pull requests are required."
  type        = bool
  default     = false
}

variable "labels" {
  description = "Issue labels to manage on the repository, keyed by label name with a hex color (no leading #)."
  type        = map(string)
  default = {
    "terraform"      = "5C4EE5"
    "windows-server" = "0078D4"
    "networking"     = "1D76DB"
    "bug"            = "D73A4A"
    "enhancement"    = "A2EEEF"
  }
}
