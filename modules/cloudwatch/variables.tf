variable "name" { type = string }
variable "autoscaling_group_name" { type = string }
variable "load_balancer_arn_suffix" { type = string }
variable "target_group_arn_suffix" { type = string }
variable "alarm_actions" { type = list(string) default = [] }
variable "cpu_alarm_threshold" { type = number default = 80 }
variable "log_retention_days" { type = number default = 30 }
variable "tags" { type = map(string) default = {} }
