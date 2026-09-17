variable "project" { type = string default = "interview" }
variable "environment" { type = string default = "prod" }
variable "region" { type = string default = "ap-south-1" }
variable "vpc_cidr" { type = string default = "10.0.0.0/16" }
variable "public_subnet_cidrs" { type = list(string) default = ["10.0.1.0/24", "10.0.2.0/24"] }
variable "private_subnet_cidrs" { type = list(string) default = ["10.0.11.0/24", "10.0.12.0/24"] }
variable "allowed_cidr_blocks" { type = list(string) default = ["0.0.0.0/0"] }
variable "certificate_arn" { type = string }
variable "instance_type" { type = string default = "t3.micro" }
variable "deletion_protection" { type = bool default = true }
variable "alarm_actions" { type = list(string) default = [] }
variable "monthly_budget_limit" { type = number default = 50 }
variable "budget_notification_email" { type = string }
