resource "aws_instance" "ec2_instance" {
    ami = "${var.amiID}"
    instance_type = "${var.instanceType}"
    availability_zone = "${var.availabilityZone}"
    security_groups = [ for sg in "${var.sgID}" : sg ]
    subnet_id = "${var.subnetID}"
    key_name = "${var.sshKeyPairName}"
}