# module "consul" {
#   source    = "../service_discovery"
#   vpc_id    = module.main_vpc.aws_vpc_id
#   subnet_id = [module.private_subnet_1.aws_subnet_id, module.private_subnet_2.aws_subnet_id]
# }
