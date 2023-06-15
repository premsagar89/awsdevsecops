resource "aws_codecommit_repository" "codecommit_repo" {
  repository_name = "${var.repositoryName}"
  description     = "${var.description}"
  default_branch = "${var.defaultBranch}"
}