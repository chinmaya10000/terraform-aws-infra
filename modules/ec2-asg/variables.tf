variable "ami_id" {}
variable "env" {}
variable "instance_type" {}
variable "web_sg_id" {}
variable "instance_profile" {}
variable "desired_capacity" {}
variable "max_size" {}
variable "min_size" {}
variable "private_subnets" {
  type = list(string)
}
variable "target_group_arn" {}