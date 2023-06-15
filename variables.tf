#################################################
              /* Global Variables */
#################################################

variable "accountID" {
  type    = number
  default = 949307570634
}
variable "region" {
  type    = string
  default ="us-east-1"
}
variable "availabilityZone" {
  type    = list(string)
  default =["us-east-1a", "us-east-1b", "us-east-1c"]
}
variable "defaultVPC" {
  type    = string
  default ="vpc-0e863a697e0233379"
}
variable "defaultVPCSubnets" {
  type    = list(string)
  default = [ "subnet-085677ea8b9af55e1", "subnet-088805a777c44597a", "subnet-057549e4b73f81642" ]
}
variable "defaultVPCSecurityGroup" {
  type    = string
  default ="sg-0fb6711522e41b1fb"
}
variable "ownerTag" {
  type    = string
  default = "premsagar89.india@gmail.com"
}
variable "envTag" {
  type    = string
  default = "Development"
}
variable "projTag" {
  type    = string
  default = "demo"
}
#################################################
              /* Local Variables */
#################################################
