resource "aws_iam_instance_profile" "instance_profile" {
  name = var.name
  role = var.role
}
