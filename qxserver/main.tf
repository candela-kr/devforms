# Specify the provider and access details
#provider "aws" {
#version = "~> 1.8"
#  region = "ap-northeast-2"
#}

resource "aws_iam_instance_profile" "rtserver_profile" {
 name = "rtserver_profile"
 role = "rtserver-role"
}

resource "aws_autoscaling_group" "rtserver" {
  availability_zones   = ["${split(",", var.availability_zones)}"]
  name                 = "rtserver"
  max_size             = "1"
  min_size             = "0"
  desired_capacity     = "1"
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.rtserver.name}"
#  load_balancers       = ["${aws_lb.rtserver.name}"]
# load_balancers       = ["rtserver-alb"]

  #vpc_zone_identifier = ["${split(",", var.availability_zones)}"]
  tag {
    key                 = "Name"
    value               = "rtserver"
    propagate_at_launch = "true"
  }
}

resource "aws_launch_configuration" "rtserver" {
  name          = "rtserver"
#  image_id      = "${lookup(var.rts_amis, "rtserver")}"
  image_id      = "${var.rtserver_ami}"
  instance_type = "${var.instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.rtserver_profile.name}"

  # Security group
  security_groups = ["${aws_security_group.rtserver.id}"]
  user_data       = "${file("rtserver/userdata.sh")}"
  key_name        = "${var.key_name}"
}

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "rtserver" {
  name        = "rtserver"
  description = "Used in the terraform"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
