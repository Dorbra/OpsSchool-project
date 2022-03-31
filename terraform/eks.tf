module "eks" {
  source                   = "../eks-terraform"
  vpc_id                   = module.main_vpc.aws_vpc_id
  private_subnets          = [module.private_subnet_1.aws_subnet_id, module.private_subnet_2.aws_subnet_id]
  jenkins_role             = module.jenkins.jenkins_role_arn
  consul_security_group_id = module.monitoring.security_group_id
}


output "k8s_cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.cluster_name
}
