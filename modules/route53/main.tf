resource "aws_route53_zone" "private" {
  name = "kandula"
  vpc {
    vpc_id = var.vpc_id
  }
}

resource "aws_route53_record" "jenkins_server" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "jenkins_server.kandula"
  type    = "A"
  ttl     = "300"
  records = [var.jenkins_server_private_ip]
}

resource "aws_route53_record" "jenkins_nodes" {
  #count   = 1
  zone_id = aws_route53_zone.private.zone_id
  name    = "jenkins_agent.kandula"
  type    = "A"
  ttl     = "300"
  records = [var.jenkins_agent_private_ip]
}

resource "aws_route53_record" "consul_servers" {
  count   = 3
  zone_id = aws_route53_zone.private.zone_id
  name    = "consul${count.index}.kandula"
  type    = "A"
  ttl     = "300"
  records = [var.consul_server_private_ip[count.index]]
}

resource "aws_route53_record" "consul_client" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "consul-client.kandula"
  type    = "A"
  ttl     = "300"
  records = [var.consul_agent_private_ip[0]]
}

resource "aws_route53_record" "prometheus_server" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "prometheus.kandula"
  type    = "A"
  ttl     = "300"
  records = [var.promcol_private_ip]
}

resource "aws_route53_record" "elk_server" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "elk.kandula"
  type    = "A"
  ttl     = "300"
  records = [var.elk_private_ip]
}


# resource "aws_route53_record" "bastion_server" {
#   zone_id = var.route53_zone_id
#   name    = "bastion.kandula"
#   type    = "A"
#   ttl     = "300"
#   records = []
# }
