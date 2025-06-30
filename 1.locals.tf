locals {
  region   = "us-east-2"
  vpc_cidr = "10.0.0.0/16"
  env      = "dev"

  azs            = ["us-east-2a", "us-east-2b", "us-east-2c"]
  public_subnets = ["10.0.0.0/19", "10.0.32.0/19"]

  private_subnets = {
    public_1 = {
      cidr = cidrsubnet(local.vpc_cidr, 3, 2)
      az   = "us-east-2a"
    }
    public_2 = {
      cidr = cidrsubnet(local.vpc_cidr, 3, 3)
      az   = "us-east-2b"
    }
  }

  # web_ingress_rules = {
  #   22 = "49.207.209.88/32"
  #   80 = "0.0.0.0/0"
  # }
  # web_egress_rules = [
  #   {
  #     from_port   = 0
  #     to_port     = 0
  #     protocol    = "-1"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }
  # ]

  # alb_ingress_rules = {
  #   80  = "0.0.0.0/0"
  #   443 = "0.0.0.0/0"
  # }

  # alb_egress_rules = [
  #   {
  #     from_port   = 443
  #     to_port     = 443
  #     protocol    = "tcp"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }
  # ]
}