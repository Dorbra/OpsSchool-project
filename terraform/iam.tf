module "nginx_role" {
  source = "../modules/iam-role"
  name   = "nginx-role-s3"
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
  managed_policy_arns = [module.S3-put-access.policy-arn]
  tags = {
    Purpose = "role for nginx instance to access S3"
  }
}

module "S3-put-access" {
  source      = "../modules/iam-policy"
  name        = "s3-policy"
  description = "S3 put access policy"
  policy = jsonencode({
    "Version" : "2012-10-17"
    "Statement" : [
      {
        "Sid" : "S3"
        "Effect" : "Allow"
        "Action" : ["s3:*"]
        "Resource" : "*"
      },
    ]
  })
}

module "nginx_instance_profile" {
  source = "../modules/iam-instance-profile"
  name   = "nginx-profile"
  role   = module.nginx_role.role-name
}

