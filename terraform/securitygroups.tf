module "nginx-sg" {
  source      = "../modules/security-group"
  name        = "nginx-server-sg"
  description = "allow ssh,http"
  vpc_id      = module.main_vpc.aws_vpc_id
  tags = {
    Name    = "allow_http-ssh",
    Owner   = "Doron",
    Purpuse = "SG for nginx"
  }
}

module "sg-rule-in-1" {
  source            = "../modules/security-group-rule"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.nginx-sg.aws_security_group_id
}

module "sg-rule-in-2" {
  source            = "../modules/security-group-rule"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.nginx-sg.aws_security_group_id
}

module "sg-rule-in-3" {
  source            = "../modules/security-group-rule"
  type              = "ingress"
  from_port         = 80
  to_port           = 8500
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.nginx-sg.aws_security_group_id
}

module "sg-rule-in-promcol" {
  source            = "../modules/security-group-rule"
  type              = "ingress"
  from_port         = 9090
  to_port           = 9090
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.nginx-sg.aws_security_group_id
}

module "sg-rule-in-grafana" {
  source            = "../modules/security-group-rule"
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.nginx-sg.aws_security_group_id
}

module "sg-rule-in-elk" {
  source            = "../modules/security-group-rule"
  type              = "ingress"
  from_port         = 5601
  to_port           = 5601
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.nginx-sg.aws_security_group_id
}

module "sg-rule-in-elastic" {
  source            = "../modules/security-group-rule"
  type              = "ingress"
  from_port         = 9200
  to_port           = 9200
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.nginx-sg.aws_security_group_id
}

module "sg-rule-out" {
  source            = "../modules/security-group-rule"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.nginx-sg.aws_security_group_id
}

module "bastion-sg" {
  source      = "../modules/security-group"
  name        = "bastion-host-sg"
  description = "allow ssh"
  vpc_id      = module.main_vpc.aws_vpc_id
  tags = {
    Name    = "allow-ssh",
    Owner   = "Doron",
    Purpuse = "SG for bastion"
  }
}

module "bastion-sg-rule-out" {
  source            = "../modules/security-group-rule"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion-sg.aws_security_group_id
}
module "bastion-sg-rule-in-ssh" {
  source            = "../modules/security-group-rule"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion-sg.aws_security_group_id
}
