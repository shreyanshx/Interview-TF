variable "name" { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "security_group_id" { type = string }
variable "instance_profile_name" { type = string }
variable "target_group_arn" { type = string }
variable "user_data_base64" { type = string }
variable "instance_type" { type = string default = "t3.micro" }
variable "root_volume_size" { type = number default = 20 }
variable "min_size" { type = number default = 2 }
variable "max_size" { type = number default = 4 }
variable "desired_capacity" { type = number default = 2 }
variable "cpu_target" { type = number default = 60 }
variable "tags" { type = map(string) default = {} }
