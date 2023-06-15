resource "aws_security_group" "security_group" {
  name        = "${var.sgName}"
  description = "${var.sgDesc}"
  vpc_id      = "${var.vpcID}"

  /* Default Inbound Rule */
  ingress {
    from_port        = -1
    to_port          = -1
    protocol         = "ICMP"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  /* Default Outbound Rule */
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group_rule" "inbound_rule" {
  type              = "ingress"
  security_group_id = "${aws_security_group.security_group.id}"
  count             = length(var.ingressRules)
  from_port         = "${var.ingressRules[count.index].from_port}"
  to_port           = "${var.ingressRules[count.index].to_port}"
  protocol          = "${var.ingressRules[count.index].protocol}"
  cidr_blocks       = "${var.ingressRules[count.index].cidr_blocks}"
  description       = "${var.ingressRules[count.index].description}"
}