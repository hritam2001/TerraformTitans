locals {
  name = "${var.prefix}-Team4"
  common_tags = {
    Project = local.name
    Owner   = var.prefix
    Managed = "Terraform"
  }
}

# Discover AZs in region (Mumbai supports a,b,c)
data "aws_availability_zones" "available" {}