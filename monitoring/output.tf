output "consul_server_id" {
  value = aws_instance.consul_server.*.id
}

output "consul_server_private_ip" {
  value = aws_instance.consul_server.*.private_ip
}

output "consul_agent_private_ip" {
  value = aws_instance.consul_client.*.private_ip
}

output "promcol_private_ip" {
  value = aws_instance.promcol.private_ip
}

output "security_group_id" {
  description = "security group for monitoring and consul module"
  value       = aws_security_group.opsschool_consul.id
}

output "prometheus_server_id" {
  value = aws_instance.promcol.id
}
