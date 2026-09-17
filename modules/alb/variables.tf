variable "name" { type = string }
variable "vpc_id" { type = string }
variable "subnet_ids" { type = list(string) }
variable "security_group_id" { type = string }
variable "certificate_arn" { type = string }
variable "application_port" { type = number default = 80 }
variable "deletion_protection" { type = bool default = true }
variable "tags" { type = map(string) default = {} }
