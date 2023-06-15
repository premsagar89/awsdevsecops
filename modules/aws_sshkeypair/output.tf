output "ssh_keypair_name" {
    value = aws_key_pair.sshkeypair.key_name
}
output "ssh_keypair_id" {
    value = aws_key_pair.sshkeypair.id
}