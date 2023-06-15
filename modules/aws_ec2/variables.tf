variable "amiID" {
  type = string
}
variable "instanceType" {
  type = string
}
variable "availabilityZone" {
  type = string
}
variable "sgID" {
  type = list(string)
}
variable "subnetID" {
  type = string
}
variable "sshKeyPairName" {
  type = string
}
