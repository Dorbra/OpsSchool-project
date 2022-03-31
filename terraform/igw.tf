module "igw" {
  source = "../modules/internet-gateway"
  vpc_id = module.main_vpc.aws_vpc_id
  tags = {
    Name = "igw",
  Environment = "prod" }
}
