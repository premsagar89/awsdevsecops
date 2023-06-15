#################################################
              /* Global Variables */
#################################################


#################################################
              /* Local Variables */
#################################################
variable "roleName" {
  type    = string
}
variable "roleDesc" {
  type    = string
}
variable "roleTrustPolicy" {
  type    = list(string)
}
variable "policyName" {
  type    = string
}
variable "policyDesc" {
  type    = string
}
variable "policyPermission" {
  type    = list(string)
}
variable "attachPolicyArn" {
  type    = list(string)
}