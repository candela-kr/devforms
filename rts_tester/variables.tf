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

variable "rts_tester_ami" {
  default = "ami-49d57727"
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
  default     = "t2.xlarge"
  description = "AWS instance type"
}

variable "asg_min" {
  description = "Min numbers of servers in ASG"
  default     = "0"
}

variable "asg_max" {
  description = "Max numbers of servers in ASG"
  default     = "8"
}

variable "asg_desired" {
  description = "Desired numbers of servers in ASG"
  default     = "0"
}

#variable "asg_tgs" {
#  default = "arn:aws:elasticloadbalancing:ap-northeast-2:912431869902:targetgroup/rtserver-group/bbf75e4466126635"
#  description = "target group arns"
#} 
