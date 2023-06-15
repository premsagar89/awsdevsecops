#################################################
              /* Local Variables */
#################################################


#################################################
              /* Local Variables */
#################################################

variable "albName" {
  type    = string
}
variable "albType" {
  type    = string
}
variable "sgID" {
  type    = string
}
variable "subnetID" {
  type    = list(string)
}
variable "tg1" {
  type    = string
}
variable "tg2" {
  type    = string
}
variable "vpcID" {
  type    = string
}
variable "albAlgoType" {
  type    = string
}
variable "albTargetType" {
  type    = string
}
variable "albTGProtocol" {
  type    = string
}
variable "albTGPort" {
  type    = number
}
variable "albListener1Port" {
  type    = number
}
variable "albListener1Protocol" {
  type    = string
}
variable "albListener1ActionType" {
  type    = string
}
variable "albListener2Port" {
  type    = number
}
variable "albListener2Protocol" {
  type    = string
}
variable "albListener2ActionType" {
  type    = string
}