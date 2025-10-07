locals {
  tags = {
    Terrafrom   = "true"
    Environment = "dev"
    Product     = "Litmus Edge Manager"
    Application = var.image_version
  }
}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

data "aws_subnet" "subnet" {
  id = var.subnet_id
}

data "aws_ami" "em_ami" {
  most_recent = true
  filter {
    name   = "name"
    values = ["${var.image_version}-*"]
  }
  owners = [var.ami_owner]
}
