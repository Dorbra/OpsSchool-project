provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "jenkins_server_ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["jenkins-ami-latest"]
  }
}

locals {
  jenkins_default_name = "jenkins"
  jenkins_home         = "/home/ubuntu/jenkins_home"
  jenkins_home_mount   = "${local.jenkins_home}:/var/jenkins_home"
  docker_sock_mount    = "/var/run/docker.sock:/var/run/docker.sock"
  java_opts            = "JAVA_OPTS='-Djenkins.install.runSetupWizard=false'"
}

data "template_file" "jenkins_server" {
  template = file("/Users/doron/OPS/ops-midproject/ci-cd/templates/jenkins.sh.tpl")

  vars = {
    consul_version        = var.consul_version
    node_exporter_version = var.node_exporter_version
    prometheus_dir        = var.prometheus_dir
    config                = <<EOF
  "node_name": "jenkins-master-server",
  "telemetry": {
    "prometheus_retention_time": "10m"
  }
EOF
  }
}

resource "aws_iam_role" "jenkins-role" {
  name = "jenkins-role"
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  tags = {
    Name = "jenkins-role"
  }
}

resource "aws_iam_policy" "jenkins-policy" {
  name = "jenkins-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
          "ec2:DescribeInstances",
          "ec2:CreateSnapshot",
          "ec2:CreateImage",
          "ec2:RegisterImage",
          "ec2:DeregisterImage",
          "sts:AssumeRole",
          "eks:DescribeCluster",

          "secretsmanager:GetResourcePolicy",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecretVersionIds"
        ]
        Effect   = "Allow",
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins-policy-role" {
  role       = aws_iam_role.jenkins-role.name
  policy_arn = aws_iam_policy.jenkins-policy.arn
}

resource "aws_iam_instance_profile" "jenkins-profile" {
  name = "jenkins-profile"
  role = aws_iam_role.jenkins-role.name
}

resource "aws_security_group" "jenkins" {
  name        = local.jenkins_default_name
  description = "Allow Jenkins inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow http from the world"
  }

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    from_port   = 8500
    to_port     = 8500
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow consul UI access from the world"
  }

  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow prometheus Metrics access from the world"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow ssh from the world"
  }

  egress {
    description = "Allow all outgoing traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = local.jenkins_default_name
  }
}

resource "aws_instance" "jenkins_server" {
  ami                         = data.aws_ami.jenkins_server_ami.id
  instance_type               = "t2.micro"
  subnet_id                   = var.master_subnet
  iam_instance_profile        = aws_iam_instance_profile.jenkins-profile.name
  key_name                    = var.key_name
  associate_public_ip_address = true
  user_data                   = file("/Users/doron/OPS/ops-midproject/ci-cd/jenkins_server_userdata.sh")
  #user_data            = file("${path.module}/jenkins_server_userdata.sh")
  #user_data = data.template_file.jenkins_server.rendered

  connection {
    host        = self.public_ip
    user        = "ubuntu"
    type        = "ssh"
    private_key = file("/Users/doron/OPS/ops-midproject/ci-cd/jenkins_ec2_key.pem")
  }

  provisioner "file" {
    source      = "/Users/doron/OPS/ops-midproject/ci-cd/node_exporter.sh"
    destination = "/home/ubuntu/node_exporter.sh"

    connection {
      user        = "ubuntu"
      type        = "ssh"
      private_key = file("/Users/doron/OPS/ops-midproject/ci-cd/jenkins_ec2_key.pem")
      host        = self.public_ip
    }
  }

  tags = {
    Name = "Jenkins Server"
  }
  vpc_security_group_ids = [
    var.default_sg,
    aws_security_group.jenkins.id,
    var.consul_security_group_id
  ]
}

resource "aws_instance" "jenkins_agent" {
  ami                  = "ami-0d4d9f5ef0923a0e8"
  instance_type        = "t2.micro"
  subnet_id            = var.agents_subnet
  iam_instance_profile = aws_iam_instance_profile.jenkins-profile.name
  key_name             = var.key_name
  #user_data            = file("${path.module}/userdata.sh")
  user_data = file("/Users/doron/OPS/ops-midproject/ci-cd/userdata.sh")

  connection {
    host        = self.public_ip
    user        = "ubuntu"
    type        = "ssh"
    private_key = file("/Users/doron/OPS/ops-midproject/ci-cd/jenkins_ec2_key.pem")
  }

  tags = {
    Name = "Jenkins Agent"
  }

  vpc_security_group_ids = [
    var.default_sg,
    aws_security_group.jenkins.id,
    var.consul_security_group_id
  ]
}

