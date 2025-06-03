module "edgemanager_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name   = "${var.name}-sg"
  vpc_id = data.aws_vpc.vpc.id

  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "http-80-tcp",
      cidr_blocks = join(",", var.ingress_cidr_blocks)
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "https-443-tcp",
      cidr_blocks = join(",", var.ingress_cidr_blocks)
    },
    {
      from_port   = 8883
      to_port     = 8883
      protocol    = "tcp"
      description = "activemq-8883-tcp",
      cidr_blocks = join(",", var.ingress_cidr_blocks)
    },
    {
      from_port   = 9092
      to_port     = 9092
      protocol    = "tcp"
      description = "kafka-broker-tcp",
      cidr_blocks = join(",", var.ingress_cidr_blocks)
    },
    {
      from_port   = 8446
      to_port     = 8446
      protocol    = "tcp"
      description = "INSIGHTS, MINIO AND LOOP_ADMIN",
      cidr_blocks = join(",", var.ingress_cidr_blocks)
    },
    {
      from_port   = 9093
      to_port     = 9093
      protocol    = "tcp"
      description = "KAFKA_SSL"
      cidr_blocks = join(",", var.ingress_cidr_blocks)
    },
    {
      from_port   = 8123
      to_port     = 8123
      protocol    = "tcp"
      description = "CLICKHOUSE_HTTP"
      cidr_blocks = join(",", var.ingress_cidr_blocks)
    },
    {
      from_port   = 8543
      to_port     = 8543
      protocol    = "tcp"
      description = "CLICKHOUSE_HTTP_SSL"
      cidr_blocks = join(",", var.ingress_cidr_blocks)
    },
    {
      from_port   = 9000
      to_port     = 9000
      protocol    = "tcp"
      description = "CLICKHOUSE_NATIVE"
      cidr_blocks = join(",", var.ingress_cidr_blocks)
    },
    {
      from_port   = 9004
      to_port     = 9004
      protocol    = "tcp"
      description = "CLICKHOUSE_MYSQL"
      cidr_blocks = join(",", var.ingress_cidr_blocks)
    },
    {
      from_port   = 51820
      to_port     = 51820
      protocol    = "udp"
      description = "WIREGUARD"
      cidr_blocks = join(",", var.ingress_cidr_blocks)
    },
    {
      from_port   = 123
      to_port     = 123
      protocol    = "udp"
      description = "NTP"
      cidr_blocks = join(",", var.ingress_cidr_blocks)
    },
    {
      from_port   = 9090
      to_port     = 9090
      protocol    = "tcp"
      description = "PROMETHEUS"
      cidr_blocks = join(",", var.ingress_cidr_blocks)
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH from specified subnets"
      cidr_blocks = join(",", var.ingress_cidr_ssh_blocks)
    },
  ]

  tags = merge(local.tags, var.tags)
}