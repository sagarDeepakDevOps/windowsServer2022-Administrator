# The GitHub provider authenticates with a Personal Access Token (PAT).
#
# SECURITY: the token is NEVER hardcoded here. The provider automatically reads
# it from the GITHUB_TOKEN environment variable. Export it before running:
#
#   export GITHUB_TOKEN="ghp_your_token_here"
#
# The PAT needs these scopes:
#   - repo        (create/manage the repository and its contents)
#   - delete_repo (only if you want `terraform destroy` to remove the repo)
#
# Create a token at: https://github.com/settings/tokens
provider "github" {
  owner = var.github_owner
}
