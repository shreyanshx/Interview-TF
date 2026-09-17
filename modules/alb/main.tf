resource "aws_lb" "this" {
  name = substr("${var.name}-alb", 0, 32)
  internal = false
  load_balancer_type = "application"
  security_groups = [var.security_group_id]
  subnets = var.subnet_ids
  enable_deletion_protection = var.deletion_protection
  tags = var.tags
}
resource "aws_lb_target_group" "this" {
  name = substr("${var.name}-tg", 0, 32)
  port = var.application_port
  protocol = "HTTP"
  target_type = "instance"
  vpc_id = var.vpc_id
  health_check { path = "/" matcher = "200" healthy_threshold = 3 unhealthy_threshold = 3 timeout = 5 interval = 30 }
  tags = var.tags
}
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port = 443
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn = var.certificate_arn
  default_action { type = "forward" target_group_arn = aws_lb_target_group.this.arn }
}
