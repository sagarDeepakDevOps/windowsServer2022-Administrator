# Terraform and provider version constraints keep this project reproducible.
# The integrations/github provider is the official, actively maintained provider.
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}
