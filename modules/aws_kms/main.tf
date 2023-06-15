/* KMS KEY */
resource "aws_kms_key" "kms" {
  description = "${var.kmsDesc}"
  key_usage = "${var.kmsUsage}"
  deletion_window_in_days = "${var.deletionWindow}"
  is_enabled = true
  enable_key_rotation = true
  multi_region = false
}