# Specify the provider and access details
provider "aws" {
  version = "~> 1.8"
  region = "ap-northeast-2"
  profile = "candelachain"
}

resource "aws_iam_instance_profile" "rtstate_profile" {
# name = "rtstate_profile"
 role = "rtserver-role"
}

resource "aws_autoscaling_group" "rtstate" {
  availability_zones   = ["${split(",", var.availability_zones)}"]
  name                 = "rtstate"
  max_size             = "1"
  min_size             = "0"
  desired_capacity     = "${var.asg_desired}"
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.rtstate.name}"
#  load_balancers       = ["${aws_elb.web-elb.name}"]

  #vpc_zone_identifier = ["${split(",", var.availability_zones)}"]
  tag {
    key                 = "Name"
    value               = "rtstate"
    propagate_at_launch = "true"
  }
}

resource "aws_launch_configuration" "rtstate" {
#  name          = "rtstate"
#  image_id      = "${lookup(var.rts_amis, "rtstate")}"
  image_id  = "${var.rtstate_ami}"
  instance_type = "${var.instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.rtstate_profile.name}"

  # Security group
  security_groups = ["${aws_security_group.rtstate.id}"]
  user_data       = "${file("rtstate/userdata.sh")}"
  key_name        = "${var.key_name}"

  lifecycle {
	create_before_destroy = true
  }
}

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "rtstate" {
  #name        = "rtstate"
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
    from_port   = 7777
    to_port     = 7777
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

  lifecycle {
	create_before_destroy = true
  }
}
