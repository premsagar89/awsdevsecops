/* ALB OUTPUT */
output "alb_arn" {
    value = aws_lb.alb.arn
}
output "alb_name" {
    value = aws_lb.alb.name
}
output "alb_dns_name" {
    value = aws_lb.alb.dns_name
}

output "alb_listener1_arn" {
    value = aws_lb_listener.alb_listener1.arn
}
output "alb_listener1_port" {
    value = aws_lb_listener.alb_listener1.port
}
output "alb_listener1_protocol" {
    value = aws_lb_listener.alb_listener1.protocol
}

output "alb_listener2_arn" {
    value = aws_lb_listener.alb_listener2.arn
}
output "alb_listener2_port" {
    value = aws_lb_listener.alb_listener2.port
}
output "alb_listener2_protocol" {
    value = aws_lb_listener.alb_listener2.protocol
}

/* TARGET GROUPS OUTPUT */
output "alb_tg1_name" {
    value = aws_lb_target_group.tg1.name
}
output "alb_tg1_arn" {
    value = aws_lb_target_group.tg1.arn
}

output "alb_tg2_name" {
    value = aws_lb_target_group.tg2.name
}
output "alb_tg2_arn" {
    value = aws_lb_target_group.tg2.arn
}