
# module "nginx-instance-1" {
#   source                 = "../modules/ec2-instance"
#   count                  = 1
#   subnet_id              = module.public_subnet_1.aws_subnet_id
#   ami                    = data.aws_ami.aws-linux.id
#   availability_zone      = "us-east-1a"
#   instance_type          = "t2.micro"
#   iam_instance_profile   = module.nginx_instance_profile.profile-arn
#   vpc_security_group_ids = [module.nginx-sg.aws_security_group_id]

#   tags = {
#     Owner     = "Doron Brand"
#     Terraform = "true"
#     Purpose   = "nginx server"
#     Name      = "nginx-1"
#   }
#   key_name  = "doronkey"
#   user_data = file("userdata.sh")
# }

# module "nginx-instance-2" {
#   source                 = "../modules/ec2-instance"
#   count                  = 1
#   subnet_id              = module.public_subnet_2.aws_subnet_id
#   ami                    = data.aws_ami.aws-linux.id
#   instance_type          = "t2.micro"
#   availability_zone      = "us-east-1b"
#   iam_instance_profile   = module.nginx_instance_profile.profile-arn
#   vpc_security_group_ids = [module.nginx-sg.aws_security_group_id]
#   tags = {
#     Owner     = "Doron Brand"
#     Terraform = "true"
#     Purpose   = "nginx server"
#     Name      = "nginx-2"
#   }
#   key_name  = "doronkey"
#   user_data = file("userdata.sh")

# }

# module "db-server-1" {
#   source                 = "../modules/ec2-instance"
#   count                  = 1
#   subnet_id              = module.private_subnet_1.aws_subnet_id
#   ami                    = data.aws_ami.aws-linux.id
#   instance_type          = "t2.micro"
#   availability_zone      = "us-east-1a"
#   vpc_security_group_ids = [module.nginx-sg.aws_security_group_id]
#   tags = {
#     Owner     = "Doron Brand"
#     Terraform = "true"
#     Purpose   = "db server"
#     Name      = "DB"
#   }
#   key_name  = "doronkey"
#   user_data = ""

# }

# module "db-server-2" {
#   source                 = "../modules/ec2-instance"
#   count                  = 1
#   subnet_id              = module.private_subnet_2.aws_subnet_id
#   ami                    = data.aws_ami.aws-linux.id
#   instance_type          = "t2.micro"
#   availability_zone      = "us-east-1b"
#   vpc_security_group_ids = [module.nginx-sg.aws_security_group_id]
#   tags = {
#     Owner     = "Doron Brand"
#     Terraform = "true"
#     Purpose   = "db server"
#     Name      = "DB"
#   }
#   key_name  = "doronkey"
#   user_data = ""

# }
