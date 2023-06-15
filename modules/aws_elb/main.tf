resource "aws_lb" "alb" {
    name = "${var.albName}"
    internal = false
    load_balancer_type = "${var.albType}"
    security_groups = [ "${var.sgID}" ]
    subnets = [ "${var.subnetID[0]}","${var.subnetID[1]}","${var.subnetID[2]}" ]
    enable_deletion_protection = false
}

###################################################################################################

/* ALB LISTENERS */
resource "aws_lb_listener" "alb_listener1" {
    load_balancer_arn = aws_lb.alb.arn
    depends_on = [ aws_lb.alb ]
    port              = "${var.albListener1Port}"
    protocol          = "${var.albListener1Protocol}"

    default_action {
        type             = "${var.albListener1ActionType}"
        target_group_arn = aws_lb_target_group.tg1.arn
    }
}

resource "aws_lb_listener" "alb_listener2" {
    load_balancer_arn = aws_lb.alb.arn
    depends_on = [ aws_lb.alb ]
    port              = "${var.albListener2Port}"
    protocol          = "${var.albListener2Protocol}"

    default_action {
        type             = "${var.albListener2ActionType}"
        target_group_arn = aws_lb_target_group.tg2.arn
    }
}

###################################################################################################

/* TARGET GROUP 1 */
resource "aws_lb_target_group" "tg1" {
    name = "${var.tg1}"
    /* depends_on = [ aws_lb_listener.alb_listener1 ] */
    port = "${var.albTGPort}"
    protocol = "${var.albTGProtocol}"
    vpc_id = "${var.vpcID}"
    load_balancing_algorithm_type = "${var.albAlgoType}"
    target_type = "${var.albTargetType}"
    health_check {
        enabled = true
        path = "/"
        healthy_threshold = 2
        unhealthy_threshold = 2
        interval = 60
        port = 80
        protocol = "HTTP"
        timeout = 30
    }
    stickiness {
        enabled = true
        type = "lb_cookie"
        cookie_duration = 120
    }
}

###################################################################################################

/* TARGET GROUP 2 */
resource "aws_lb_target_group" "tg2" {
    name = "${var.tg2}"
    /* depends_on = [ aws_lb_listener.alb_listener2 ] */
    port = "${var.albTGPort}"
    protocol = "${var.albTGProtocol}"
    vpc_id = "${var.vpcID}"
    load_balancing_algorithm_type = "${var.albAlgoType}"
    target_type = "${var.albTargetType}"
    health_check {
        enabled = true
        path = "/"
        healthy_threshold = 2
        unhealthy_threshold = 2
        interval = 60
        port = 81
        protocol = "HTTP"
        timeout = 30
    }
    stickiness {
        enabled = true
        type = "lb_cookie"
        cookie_duration = 120
    }
}