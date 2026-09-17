locals {
  name = "${var.project}-${var.environment}"
  tags = { Project = var.project, Environment = var.environment, ManagedBy = "Terraform" }
}

module "vpc" {
  source = "../../modules/vpc"
  name = local.name
  vpc_cidr = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  tags = local.tags
}
module "security_groups" {
  source = "../../modules/security-group"
  name = local.name
  vpc_id = module.vpc.vpc_id
  vpc_cidr = var.vpc_cidr
  allowed_cidr_blocks = var.allowed_cidr_blocks
  tags = local.tags
}
module "iam" { source = "../../modules/iam" name = local.name tags = local.tags }
module "alb" {
  source = "../../modules/alb"
  name = local.name
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_ids
  security_group_id = module.security_groups.alb_security_group_id
  certificate_arn = var.certificate_arn
  deletion_protection = var.deletion_protection
  tags = local.tags
}
module "application" {
  source = "../../modules/ec2-asg"
  name = local.name
  private_subnet_ids = module.vpc.private_subnet_ids
  security_group_id = module.security_groups.application_security_group_id
  instance_profile_name = module.iam.instance_profile_name
  target_group_arn = module.alb.target_group_arn
  user_data_base64 = base64encode(templatefile("${path.module}/../../user-data/install_nginx.sh", { log_group_name = "/${local.name}/application", region = var.region }))
  instance_type = var.instance_type
  tags = local.tags
}
module "cloudwatch" {
  source = "../../modules/cloudwatch"
  name = local.name
  autoscaling_group_name = module.application.autoscaling_group_name
  load_balancer_arn_suffix = module.alb.arn_suffix
  target_group_arn_suffix = module.alb.target_group_arn_suffix
  alarm_actions = var.alarm_actions
  tags = local.tags
}
resource "aws_budgets_budget" "monthly" {
  name = "${local.name}-monthly"
  budget_type = "COST"
  limit_amount = var.monthly_budget_limit
  limit_unit = "USD"
  time_unit = "MONTHLY"
  notification { comparison_operator = "GREATER_THAN" threshold = 80 threshold_type = "PERCENTAGE" notification_type = "FORECASTED" subscriber_email_addresses = [var.budget_notification_email] }
}
