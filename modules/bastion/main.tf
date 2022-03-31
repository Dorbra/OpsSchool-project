# resource "aws_instance" "bastion_host" {
#   ami                    = var.ami
#   instance_type          = var.instance_type
#   subnet_id              = module.public_subnet_2.aws_subnet_id
#   vpc_security_group_ids = [module.bastion-sg.aws_security_group_id]
#   key_name               = var.key_name
#   availability_zone      = var.availability_zone
#   user_data              = var.user_data
#   tags                   = var.tags
# }


resource "aws_instance" "bastion_host" {
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = var.vpc_security_group_ids
  key_name                    = var.key_name
  count                       = var.ec2_count
  associate_public_ip_address = true
  subnet_id                   = var.subnet_id
  tags                        = var.tags

  provisioner "file" {
    source      = "/Users/doron/OPS/ops-midproject/ci-cd/jenkins_ec2_key.pem"
    destination = "/home/ec2-user/jenkins_ec2_key.pem"

    connection {
      user        = "ec2-user"
      type        = "ssh"
      private_key = file("./doronkey.pem")
      host        = self.public_ip
    }
  }

  provisioner "file" {
    source      = "/Users/doron/OPS/ops-midproject/monitoring/monitoring.pem"
    destination = "/home/ec2-user/monitoring.pem"

    connection {
      user        = "ec2-user"
      type        = "ssh"
      private_key = file("./doronkey.pem")
      host        = self.public_ip
    }
  }

}
