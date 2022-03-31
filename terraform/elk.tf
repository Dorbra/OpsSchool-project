module "elk" {
  source                   = "../modules/elk"
  aws_vpc                  = module.main_vpc.aws_vpc_id
  aws_subnet_ids           = [module.public_subnet_1.aws_subnet_id]
  consul_security_group_id = module.monitoring.security_group_id
}
