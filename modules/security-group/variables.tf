variable "name" { type = string }
variable "vpc_id" { type = string }
variable "vpc_cidr" { type = string }
variable "application_port" { type = number default = 80 }
variable "allowed_cidr_blocks" { type = list(string) default = ["0.0.0.0/0"] }
variable "tags" { type = map(string) default = {} }
