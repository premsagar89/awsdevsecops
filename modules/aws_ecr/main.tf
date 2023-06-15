resource "aws_ecr_repository" "ecr" {
    name = "${var.ecrName}"
    image_tag_mutability = "${var.ecrImageTagMutability}"
    force_delete = false
    image_scanning_configuration {
        scan_on_push = true
    }
}