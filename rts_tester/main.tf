# Specify the provider and access details
provider "aws" {
  version = "~> 1.8"
  region = "ap-northeast-2"
  profile = "candelachain"
}

resource "aws_iam_instance_profile" "rts_tester_profile" {
# name = "rtserver_profile"
 role = "rtserver-role"
}

resource "aws_autoscaling_group" "rts_tester" {
  availability_zones   = ["${split(",", var.availability_zones)}"]
  name                 = "rts_tester"
  max_size             = "${var.asg_max}"
  min_size             = "${var.asg_min}"
  desired_capacity     = "${var.asg_desired}"
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.rts_tester.name}"
#  load_balancers       = ["${aws_lb.rtserver.name}"]
# load_balancers       = ["rtserver-alb"]

#  target_group_arns = [ "${var.asg_tgs}" ]

  #vpc_zone_identifier = ["${split(",", var.availability_zones)}"]
  tag {
    key                 = "Name"
    value               = "rts_tester"
    propagate_at_launch = "true"
  }
}

resource "aws_launch_configuration" "rts_tester" {
#  name          = "rtserver"
#  image_id      = "${lookup(var.rts_amis, "rtserver")}"
  image_id      = "${var.rts_tester_ami}"
  instance_type = "${var.instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.rts_tester_profile.name}"

  # Security group
  security_groups = ["${aws_security_group.rts_tester.id}"]
  user_data       = "${file("rts_tester/userdata.sh")}"
  key_name        = "${var.key_name}"
}

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "rts_tester" {
#  name        = "rtserver"
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
