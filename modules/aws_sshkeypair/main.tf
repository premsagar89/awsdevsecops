resource "aws_key_pair" "sshkeypair" {
  key_name   = "${var.sshKeyPairName}"
  public_key = file("${path.module}/sshkeypair.pub")
}