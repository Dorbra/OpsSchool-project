
output "jenkins_server_public_ip" {
  value = aws_instance.jenkins_server.public_ip
}

output "jenkins_server_private_ip" {
  value = aws_instance.jenkins_server.private_ip
}

output "jenkins_agent_private_ip" {
  value = aws_instance.jenkins_agent.private_ip
}

output "jenkins_role_arn" {
  value = aws_iam_role.jenkins-role.arn
}
