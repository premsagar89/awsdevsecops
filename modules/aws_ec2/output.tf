output "ec2_instance_id" {
    value = aws_instance.ec2_instance.id
}
output "ec2_instance_arn" {
    value = aws_instance.ec2_instance.arn
}
output "ec2_instance_type" {
    value = aws_instance.ec2_instance.instance_type
}
output "ec2_instance_key-pair_name" {
    value = aws_instance.ec2_instance.key_name
}
output "ec2_instance_public_dns" {
    value = aws_instance.ec2_instance.public_dns
}
output "ec2_instance_public_ip" {
    value = aws_instance.ec2_instance.public_ip
}