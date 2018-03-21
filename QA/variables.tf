variable "region" {
  description = "The AWS region to create things in."
  default     = "ap-northeast-2"
}

variable "qa_rqw_server_ami" {
  default = "ami-b2f456dc"
  description = "AMI id for server"
}

variable "availability_zones" {
  default     = "ap-northeast-2c,ap-northeast-2a"
  description = "List of availability zones, use AWS CLI to find your "
}

variable "key_name" {
  default = "rtserverkey"
  description = "Name of AWS key pair"
}

variable "instance_type" {
  default     = "t2.small"
  description = "AWS instance type"
}

variable "asg_min" {
  description = "Min numbers of servers in ASG"
  default     = "1"
}

variable "asg_max" {
  description = "Max numbers of servers in ASG"
  default     = "1"
}

variable "asg_desired" {
  description = "Desired numbers of servers in ASG"
  default     = "1"
}
