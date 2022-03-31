module "route53" {
  source                    = "../modules/route53"
  vpc_id                    = module.main_vpc.aws_vpc_id
  jenkins_server_private_ip = module.jenkins.jenkins_server_private_ip
  jenkins_agent_private_ip  = module.jenkins.jenkins_agent_private_ip
  promcol_private_ip        = module.monitoring.promcol_private_ip
  consul_server_private_ip  = module.monitoring.consul_server_private_ip
  consul_agent_private_ip   = module.monitoring.consul_agent_private_ip
  elk_private_ip            = module.elk.private_ip
}
