#################################################
              /* Global Variables */
#################################################


#################################################
              /* Local Variables */
#################################################
variable "ecsName" {
  type    = string
}
variable "ecsClusterName" {
  type    = string
}
variable "confLogging" {
  type    = string
}
variable "ecsTaskFamily" {
  type    = string
}
variable "OSFamily" {
  type    = string
}
variable "CPUArch" {
  type    = string
}
variable "ephemeralStorage" {
  type    = number
}
variable "networkMode" {
  type    = string
}
variable "vpcSubnets" {
  type    = list(string)
}
variable "requiresCompatibilities" {
  type    = string
}
variable "fargateCPU" {
  type    = number
}
variable "fargateMemory" {
  type    = number
}
variable "ecsServiceName" {
  type    = string
}
variable "launchType" {
  type    = string
}
variable "platformVersion" {
  type    = string
}
variable "nodeCount" {
  type    = number
}
variable "deploymentControllerType" {
  type    = string
}
variable "targetGrpArn" {
  type    = string
}
variable "containerName" {
  type    = string
}
variable "containerPort" {
  type    = number
}
variable "kmsKeyId" {
  type    = string
}