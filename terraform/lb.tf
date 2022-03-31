module "lb" {
  source             = "../modules/lb"
  name               = "web-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.nginx-sg.aws_security_group_id]
  subnets            = [module.public_subnet_1.aws_subnet_id, module.public_subnet_2.aws_subnet_id]

  tags = {
    Name        = "consul-lb"
    Environment = "production"
    type        = "Application"
  }
}

output "LoadBalancer" {
  value = module.lb.lb_dns_name
}
