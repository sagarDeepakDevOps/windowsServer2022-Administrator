# Useful values after the repository is created.
output "repository_full_name" {
  description = "owner/name of the repository."
  value       = github_repository.repo.full_name
}

output "repository_html_url" {
  description = "Web URL of the repository."
  value       = github_repository.repo.html_url
}

output "repository_http_clone_url" {
  description = "HTTPS clone URL."
  value       = github_repository.repo.http_clone_url
}

output "repository_ssh_clone_url" {
  description = "SSH clone URL."
  value       = github_repository.repo.ssh_clone_url
}

output "default_branch" {
  description = "The default branch name."
  value       = github_branch_default.default.branch
}
