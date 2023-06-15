resource "aws_s3_bucket" "s3" {
  bucket = "${var.bucketName}-${formatdate("DDMMYYYYhhmmss", timestamp())}"
}