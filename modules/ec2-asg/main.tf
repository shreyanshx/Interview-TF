data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]
  filter { name = "name" values = ["al2023-ami-*-x86_64"] }
  filter { name = "architecture" values = ["x86_64"] }
}
resource "aws_launch_template" "this" {
  name_prefix = "${var.name}-"
  image_id = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  vpc_security_group_ids = [var.security_group_id]
  user_data = var.user_data_base64
  iam_instance_profile { name = var.instance_profile_name }
  metadata_options { http_endpoint = "enabled" http_tokens = "required" }
  block_device_mappings { device_name = "/dev/xvda" ebs { encrypted = true volume_type = "gp3" volume_size = var.root_volume_size } }
  monitoring { enabled = true }
  tag_specifications { resource_type = "instance" tags = merge(var.tags, { Name = "${var.name}-application" }) }
}
resource "aws_autoscaling_group" "this" {
  name = "${var.name}-application"
  min_size = var.min_size
  max_size = var.max_size
  desired_capacity = var.desired_capacity
  vpc_zone_identifier = var.private_subnet_ids
  target_group_arns = [var.target_group_arn]
  health_check_type = "ELB"
  health_check_grace_period = 180
  launch_template { id = aws_launch_template.this.id version = "$Latest" }
  tag { key = "Name" value = "${var.name}-application" propagate_at_launch = true }
}
resource "aws_autoscaling_policy" "cpu" {
  name = "${var.name}-cpu-target"
  autoscaling_group_name = aws_autoscaling_group.this.name
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration { predefined_metric_specification { predefined_metric_type = "ASGAverageCPUUtilization" } target_value = var.cpu_target }
}
