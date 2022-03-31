output "eip_alloc_id" {
  value = aws_eip.eip.id
}

output "public_ip" {
  value = aws_eip.eip.public_ip
}
