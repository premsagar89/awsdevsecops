output "ecs_cluster_name" {
    value = aws_ecs_cluster.ecs_cluster.name
}
output "ecs_cluster_arn" {
    value = aws_ecs_cluster.ecs_cluster.arn
}
output "ecs_cluster_service_name" {
    value = aws_ecs_service.ecs_service.name
}
output "ecs_cluster_task_def_arn" {
    value = aws_ecs_task_definition.ecs_task_def.arn
}
output "cloudwatch_log_group" {
    value = aws_cloudwatch_log_group.cloudwatch_log_group.arn
}
