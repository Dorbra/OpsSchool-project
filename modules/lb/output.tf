output "lb-arn" {
  value = aws_lb.lb.arn
}

output "lb-id" {
  value = aws_lb.lb.arn_suffix
}

output "lb-name" {
  value = aws_lb.lb.name
}

output "lb_dns_name" {
  value = aws_lb.lb.dns_name
}
