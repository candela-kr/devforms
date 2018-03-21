# Specify the provider and access details
provider "aws" {
  version = "~> 1.8"
  region = "ap-northeast-2"
  profile = "candelachain"
}

resource "aws_iam_instance_profile" "rtbroker_profile" {
# name = "rtbroker_profile"
 role = "rtserver-role"
}

resource "aws_autoscaling_group" "rtbroker" {
  availability_zones   = ["${split(",", var.availability_zones)}"]
  name                 = "rtbroker"
  max_size             = "2"
  min_size             = "0"
  desired_capacity     = "${var.asg_desired}"
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.rtbroker.name}"
#  load_balancers       = ["${aws_elb.web-elb.name}"]

  #vpc_zone_identifier = ["${split(",", var.availability_zones)}"]
  tag {
    key                 = "Name"
    value               = "rtbroker"
    propagate_at_launch = "true"
  }
  
  lifecycle {
   create_before_destroy = true
  }
}

resource "aws_launch_configuration" "rtbroker" {
# name          = "rtbroker"
#  image_id      = "${lookup(var.rts_amis, "rtbroker")}"
  image_id      = "${var.rtbroker_ami}"
  instance_type = "${var.instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.rtbroker_profile.name}"

  # Security group
  security_groups = ["${aws_security_group.rtbroker.id}"]
  user_data       = "${file("rtbroker/userdata.sh")}"
  key_name        = "${var.key_name}"
  lifecycle {
    create_before_destroy = true
  }
}

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "rtbroker" {
#  name        = "rtbroker"
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
    from_port   = 8888
    to_port     = 8888
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
