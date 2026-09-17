output "vpc_id" { value = module.vpc.vpc_id }
output "application_url" { value = "https://${module.alb.dns_name}" }
