module "rds" {
  source          = "../modules/rds"
  vpc_id          = module.main_vpc.aws_vpc_id
  subnet_frontend = module.public_subnet_1.aws_subnet_id
  subnet_backend  = module.public_subnet_2.aws_subnet_id

}
