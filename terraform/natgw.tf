module "nat_gateway" {
  source        = "../modules/nat-gateway"
  allocation_id = module.eip.eip_alloc_id
  subnet_id     = module.public_subnet_1.aws_subnet_id

  tags = {
    Name        = "gw NAT",
    Environment = "prod"
  }
  depends_on = [module.igw.igw-id, module.eip.eip_alloc_id]
}
