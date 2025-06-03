provider "aws" {
  region = "us-east-1"
}

module "edgemanager-example" {
  source                  = "git@github.com:litmusautomation/lem-module//aws?ref=main"
  name                    = "edgemanager-example-aws"
  vpc_id                  = "vpc-xxxxxxxxxxxxxxxxx"    # vpc id
  subnet_id               = "subnet-xxxxxxxxxxxxxxxxx" # subnet id
  key_name                = "xxxxxxxxxxxxxxxxx"        # key pair name
  oem_name                = "edgemanager"
  app_version             = "2.25.0"
  aws_account_id          = "xxxxxxxxxxxxxxxxx"                   # aws account id
  ssh_pub_key             = "ssh-rsa xxxxxxxxxxxxxxxxx user@host" # optional custom ssh public key
  ingress_cidr_blocks     = ["0.0.0.0/0"]
  ingress_cidr_ssh_blocks = ["0.0.0.0/0"]
}
