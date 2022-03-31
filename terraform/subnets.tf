
module "public_subnet_1" {
  source                  = "../modules/subnet"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  vpc_id                  = module.main_vpc.aws_vpc_id
  cidr_block              = cidrsubnet(var.network_info, 8, 0) #10.0.0.0/24
  tags = {
    Name        = "public-subnet-1",
    Environment = "prod",
    Purpose     = "public subnet for web app"
  }
}

module "public_subnet_2" {
  source                  = "../modules/subnet"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
  vpc_id                  = module.main_vpc.aws_vpc_id
  cidr_block              = cidrsubnet(var.network_info, 8, 1) #10.0.1.0/24
  tags = {
    Name        = "public-subnet-2",
    Environment = "prod",
    Purpose     = "public subnet for web app"
  }
}

module "private_subnet_1" {
  source                  = "../modules/subnet"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1a"
  vpc_id                  = module.main_vpc.aws_vpc_id
  cidr_block              = cidrsubnet(var.network_info, 8, 10) #10.0.10.0/24
  tags = {
    Name        = "private-subnet-1",
    Environment = "prod",
    Purpose     = "private subnet for web app"
  }
}

module "private_subnet_2" {
  source                  = "../modules/subnet"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1b"
  vpc_id                  = module.main_vpc.aws_vpc_id
  cidr_block              = cidrsubnet(var.network_info, 8, 11) #10.0.11.0/24
  tags = {
    Name        = "private-subnet-2",
    Environment = "prod",
    Purpose     = "private subnet for web app"
  }
}
