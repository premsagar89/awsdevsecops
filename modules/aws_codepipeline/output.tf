output "codepipeline_name" {
    value = aws_codepipeline.codepipeline.name
}
output "codepipeline_arn" {
    value = aws_codepipeline.codepipeline.arn
}
output "codepipeline_artifact_store" {
    value = aws_codepipeline.codepipeline.artifact_store
}