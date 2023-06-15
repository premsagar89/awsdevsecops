output "codecommit_repository_id" {
    value = aws_codecommit_repository.codecommit_repo.id
}
output "codecommit_repository_arn" {
    value = aws_codecommit_repository.codecommit_repo.arn
}
output "codecommit_repository_clone_url_http" {
    value = aws_codecommit_repository.codecommit_repo.clone_url_http
}
output "codecommit_repository_name" {
    value = aws_codecommit_repository.codecommit_repo.repository_name
}
output "codecommit_repository_default_branch" {
    value = aws_codecommit_repository.codecommit_repo.default_branch
}