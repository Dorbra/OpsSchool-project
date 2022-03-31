module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.24.0"
  cluster_name    = local.cluster_name
  cluster_version = var.kubernetes_version
  subnets         = var.private_subnets
  enable_irsa     = true
  vpc_id          = var.vpc_id
  #user_data       = file("${path.module}/userdata.sh")

  map_roles = [
    {
      rolearn  = var.jenkins_role
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:masters", "system:bootstrappers", "system:nodes"]
    }
  ]

  tags = {
    Environment = "training"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t3.medium"
      additional_userdata           = file("${path.module}/userdata.sh")
      asg_desired_capacity          = 2
      additional_security_group_ids = [aws_security_group.all_worker_mgmt.id, var.consul_security_group_id]
    },
    {
      name                          = "worker-group-2"
      instance_type                 = "t3.large"
      additional_userdata           = file("${path.module}/userdata.sh")
      asg_desired_capacity          = 2
      additional_security_group_ids = [aws_security_group.all_worker_mgmt.id, var.consul_security_group_id]
    }
  ]
}

data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_id
}
data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_id
}
