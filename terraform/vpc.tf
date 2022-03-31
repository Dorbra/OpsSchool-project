module "main_vpc" {
  source     = "../modules/vpc"
  cidr_block = var.network_info
  tags = {
    Name        = "prod-vpc",
    Environment = "prod",
    Purpose     = "vpc for web app"
  }
}
