module "vpc" {
  source          = "./modules/vpc"
  vpc_cidr        = local.vpc_cidr
  azs             = local.azs
  env             = local.env
  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets
}

module "security_groups" {
  source           = "./modules/security-groups"
  vpc_id           = module.vpc.vpc_id
  web_ingress_cidr = local.web_ingress_cidr
  env              = local.env
}

module "alb" {
  source         = "./modules/alb"
  env            = local.env
  alb_sg_id      = module.security_groups.alb_sg_id
  public_subnets = module.vpc.public_subnets
  vpc_id         = module.vpc.vpc_id
  web_tg_name    = local.web_tg_name
}

module "iam" {
  source = "./modules/iam"
  env    = local.env
}

module "ec2_asg" {
  source           = "./modules/ec2-asg"
  ami_id           = local.ami_id
  env              = local.env
  instance_type    = local.instance_type
  web_sg_id        = module.security_groups.web_sg_id
  instance_profile = module.iam.instance_profile_name
  desired_capacity = local.desired_capacity
  max_size         = local.max_size
  min_size         = local.min_size
  private_subnets  = module.vpc.private_subnets
  target_group_arn = module.alb.web_tg_arn
}

module "cloudwatch_sns" {
  source             = "./modules/cloudwatch-sns"
  env                = local.env
  asg_name           = module.ec2_asg.asg_name
  notification_email = local.asg_notification_email
}