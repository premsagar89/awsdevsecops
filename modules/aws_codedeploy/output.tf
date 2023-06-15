output "codedeploy_app_name" {
    value = aws_codedeploy_app.codedeploy_app.name
}
output "codedeploy_app_arn" {
    value = aws_codedeploy_app.codedeploy_app.arn
}
output "codedeploy_app_id" {
    value = aws_codedeploy_app.codedeploy_app.id
}
output "code_deployment_group_name" {
    value = aws_codedeploy_deployment_group.code_deployment_group.deployment_group_name
}
output "code_deployment_group_arn" {
    value = aws_codedeploy_deployment_group.code_deployment_group.arn
}
output "code_deployment_group_id" {
    value = aws_codedeploy_deployment_group.code_deployment_group.deployment_group_id
}