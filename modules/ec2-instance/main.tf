resource "aws_instance" "ec2_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = var.vpc_security_group_ids
  tags                   = var.tags
  key_name               = var.key_name
  user_data              = var.user_data
  count                  = var.ec2_count
  availability_zone      = var.availability_zone
  subnet_id              = var.subnet_id
  iam_instance_profile   = var.iam_instance_profile
}
