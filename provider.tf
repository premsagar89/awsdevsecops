#Configure AWS Provider
provider "aws" {
  region = var.region
  default_tags {
    tags = {
      "Owner" = "${var.ownerTag}"
      "Environment" = "${var.envTag}"
      "project" = "${var.projTag}"
    }
  }
}