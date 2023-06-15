variable "sgName" {
  type = string
}
variable "sgDesc" {
  type = string
}
variable "vpcID" {
  type = string
}
variable "ingressRules" {
  type = list(object({
    from_port = number
    to_port = number
    protocol = string
    cidr_blocks = list(string)
    description = string
  }))
}