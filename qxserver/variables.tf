variable "region" {
  description = "The AWS region to create things in."
  default     = "ap-northeast-2"
}

# rts amis
variable "rts_amis" {
  default = {
    "rtstate" = "ami-af3497c1"
    "rtbroker" = "ami-eb258685"
    "rtserver" = "ami-eb258685"
  }
}

variable "rtserver_ami" {
  default = "ami-3f389b51"
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
  default     = "t2.medium"
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
