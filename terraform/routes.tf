
module "nat-route-table" {
  source     = "../modules/route-table"
  vpc_id     = module.main_vpc.aws_vpc_id
  cidr_block = "0.0.0.0/0"
  gateway_id = module.nat_gateway.ngw_id
}

module "igw-route-table" {
  source     = "../modules/route-table"
  vpc_id     = module.main_vpc.aws_vpc_id
  cidr_block = "0.0.0.0/0"
  gateway_id = module.igw.igw-id
}

module "rt-assoc-pub-1" {
  source         = "../modules/route-table-association"
  subnet_id      = module.public_subnet_1.aws_subnet_id
  route_table_id = module.igw-route-table.route_table_id
}

module "rt-assoc-pub-2" {
  source         = "../modules/route-table-association"
  subnet_id      = module.public_subnet_2.aws_subnet_id
  route_table_id = module.igw-route-table.route_table_id
}

module "rt-assoc-prv-1" {
  source         = "../modules/route-table-association"
  subnet_id      = module.private_subnet_1.aws_subnet_id
  route_table_id = module.nat-route-table.route_table_id
}

module "rt-assoc-prv-2" {
  source         = "../modules/route-table-association"
  subnet_id      = module.private_subnet_2.aws_subnet_id
  route_table_id = module.nat-route-table.route_table_id
}
