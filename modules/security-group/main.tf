resource "aws_security_group" "alb" {
  name = "${var.name}-alb"
  description = "Allows HTTPS traffic to the load balancer"
  vpc_id = var.vpc_id
  ingress { from_port = 443 to_port = 443 protocol = "tcp" cidr_blocks = var.allowed_cidr_blocks }
  egress { from_port = 80 to_port = 80 protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] }
  tags = merge(var.tags, { Name = "${var.name}-alb-sg" })
}
resource "aws_security_group" "application" {
  name = "${var.name}-application"
  description = "Allows application traffic only from the load balancer"
  vpc_id = var.vpc_id
  ingress { from_port = var.application_port to_port = var.application_port protocol = "tcp" security_groups = [aws_security_group.alb.id] }
  egress { from_port = 443 to_port = 443 protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] }
  egress { from_port = 53 to_port = 53 protocol = "udp" cidr_blocks = [var.vpc_cidr] }
  egress { from_port = 53 to_port = 53 protocol = "tcp" cidr_blocks = [var.vpc_cidr] }
  tags = merge(var.tags, { Name = "${var.name}-application-sg" })
}
