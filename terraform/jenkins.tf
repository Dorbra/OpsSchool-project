module "jenkins" {
  source                   = "../ci-cd"
  key_name                 = "jenkins_ec2_key"
  master_subnet            = module.public_subnet_1.aws_subnet_id
  agents_subnet            = module.private_subnet_1.aws_subnet_id
  vpc_id                   = module.main_vpc.aws_vpc_id
  default_sg               = module.main_vpc.default_sg_id
  consul_security_group_id = module.monitoring.security_group_id
}

output "jenkins_master_public_ip" {
  value = module.jenkins.jenkins_server_public_ip
}
