locals {
  tcp_ports = [
    80, 443, 8883,
    9092, 8446, 9093,
    8123, 8543, 9000,
    9004, 9090,
  ]

  udp_ports = [
    51820, 123
  ]

  ssh_ports = [
    22
  ]

  tcp_rules = [
    for port in local.tcp_ports : {
      from_port   = port
      to_port     = port
      protocol    = "tcp"
      description = "tcp-${port}"
      cidr_blocks = join(",", var.ingress_cidr_blocks)
    }
  ]

  udp_rules = [
    for port in local.udp_ports : {
      from_port   = port
      to_port     = port
      protocol    = "udp"
      description = "udp-${port}"
      cidr_blocks = join(",", var.ingress_cidr_blocks)
    }
  ]

  ssh_rule = [
    for port in local.ssh_ports : {
      from_port   = port
      to_port     = port
      protocol    = "tcp"
      description = "SSH from specific subnets"
      cidr_blocks = join(",", var.ingress_cidr_ssh_blocks)
    }
  ]
}

module "edgemanager_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name   = "${var.name}-sg"
  vpc_id = data.aws_vpc.vpc.id

  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]

  ingress_with_cidr_blocks = concat(local.tcp_rules, local.udp_rules)

  tags = merge(local.tags, var.tags)
}