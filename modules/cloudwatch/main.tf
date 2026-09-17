resource "aws_cloudwatch_log_group" "application" {
  name = "/${var.name}/application"
  retention_in_days = var.log_retention_days
  tags = var.tags
}
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name = "${var.name}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = 2
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = 300
  statistic = "Average"
  threshold = var.cpu_alarm_threshold
  alarm_description = "Average instance CPU exceeded the configured threshold."
  dimensions = { AutoScalingGroupName = var.autoscaling_group_name }
  alarm_actions = var.alarm_actions
}
resource "aws_cloudwatch_metric_alarm" "unhealthy_targets" {
  alarm_name = "${var.name}-unhealthy-targets"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = 2
  metric_name = "UnHealthyHostCount"
  namespace = "AWS/ApplicationELB"
  period = 60
  statistic = "Maximum"
  threshold = 1
  alarm_description = "The load balancer has unhealthy targets."
  dimensions = { LoadBalancer = var.load_balancer_arn_suffix, TargetGroup = var.target_group_arn_suffix }
  alarm_actions = var.alarm_actions
}
