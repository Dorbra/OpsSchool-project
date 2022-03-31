provider "aws" {
  region = var.aws_region
}

data "aws_subnet_ids" "subnets" {
  vpc_id = var.vpc_id
}

data "aws_ami" "amazon-linux-2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# resource "tls_private_key" "prv_key" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "aws_key_pair" "server_key" {
#   key_name   = "server_key"
#   public_key = tls_private_key.server_key.public_key_openssh
# }

data "aws_vpc" "selected" {
  id = var.vpc_id
}

resource "aws_security_group" "ansible-sg" {
  name        = "ansible-sg-7"
  description = "security group for ansible servers"
  vpc_id      = var.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    iterator = port
    for_each = var.ingress_ports
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "server" {
  count         = 1
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  associate_public_ip_address = true

  subnet_id = var.subnet_id

  vpc_security_group_ids = [aws_security_group.ansible-sg.id]
  key_name               = aws_key_pair.ansible_key.key_name

  tags = {
    Name = "Server"
  }
  user_data = <<EOF
		#! /bin/bash
    sudo apt-get update
    sudo apt install python3-pip
    sudo python3 -m pip install ansible
    sudo pip3 install boto3
    sudo apt-get -y install python-boto3
    git config --global user.name "Dorbra"
    git config --global user.email "guruda1@gmail.com"
    ssh -T git@github.com
    git clone git@github.com:dorbra/configuration-management.git
	EOF

  provisioner "file" {
    source      = "/Users/doron/ops/ops-midproject/ansible_key"
    destination = "/home/ubuntu/ansible_key.pem"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("/Users/doron/ops/ops-midproject/ansible_key.pem")
      host        = self.public_ip
    }
  }

  provisioner "file" {
    source      = "/Users/doron/ops/AWS-and-Terraform/midproj/id_rsa"
    destination = "/home/ubuntu/.ssh/id_rsa"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("/Users/doron/ops/AWS-and-Terraform/midproj/id_rsa.pem")
      host        = self.public_ip
    }
  }

  provisioner "file" {
    source      = "/Users/doron/ops/AWS-and-Terraform/midproj/id_rsa.pub"
    destination = "/home/ubuntu/.ssh/id_rsa.pub"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("/Users/doron/ops/AWS-and-Terraform/midproj/ansible_key.pem")
      host        = self.public_ip
    }
  }

  provisioner "file" {
    source      = "/Users/doron/ops/AWS-and-Terraform/midproj/known_hosts"
    destination = "/home/ubuntu/.ssh/known_hosts"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("/Users/doron/ops/AWS-and-Terraform/midproj/known_hosts.pem")
      host        = self.public_ip
    }
  }
}

resource "aws_instance" "nodes" {
  count = 2

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  associate_public_ip_address = true

  subnet_id = var.subnet_id

  vpc_security_group_ids = [aws_security_group.ansible-sg.id]
  key_name               = aws_key_pair.ansible_key.key_name

  tags = {
    Name = "Node${count.index}"
  }
}

resource "aws_instance" "nodes-redhat" {
  count = 1

  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = "t2.micro"

  associate_public_ip_address = true

  subnet_id = var.subnet_id

  vpc_security_group_ids = [aws_security_group.ansible-sg.id]
  key_name               = aws_key_pair.ansible_key.key_name

  tags = {
    Name = "Node-2"
  }
}
