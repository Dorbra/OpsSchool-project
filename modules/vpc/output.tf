output "aws_vpc_id" {
  value = aws_vpc.main.id
}

output "aws_vpc_arn" {
  value = aws_vpc.main.arn
}

output "default_sg_id" {
  value = aws_vpc.main.default_security_group_id
}
