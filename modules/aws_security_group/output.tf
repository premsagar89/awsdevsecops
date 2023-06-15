output "sg_name" {
  value = aws_security_group.security_group.name
}
output "sg_arn" {
  value = aws_security_group.security_group.arn
}
output "sg_id" {
  value = aws_security_group.security_group.id
}
output "sg_inbound_rules" {
  value = aws_security_group.security_group.ingress
}
output "sg_outbound_rules" {
  value = aws_security_group.security_group.egress
}