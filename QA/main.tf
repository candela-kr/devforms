# Specify the provider and access details
provider "aws" {
  version = "~> 1.8"
  region = "ap-northeast-2"
  profile = "candelachain"
}

resource "aws_iam_instance_profile" "qa_rqw_server_profile" {
 name = "qa_rqw_server_profile"
 role = "rtserver-role"
}

resource "aws_autoscaling_group" "qa_rqw_server" {
  availability_zones   = ["${split(",", var.availability_zones)}"]
  name                 = "qa_rqw_server"
  max_size             = "${var.asg_max}"
  min_size             = "0"
  desired_capacity     = "${var.asg_desired}"
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.qa_rqw_server.name}"
#  load_balancers       = ["${aws_lb.qaserver.name}"]
# load_balancers       = ["qaserver-alb"]

  #vpc_zone_identifier = ["${split(",", var.availability_zones)}"]
  tag {
    key                 = "Name"
    value               = "qa_rqw_server"
    propagate_at_launch = "true"
  }
}

resource "aws_launch_configuration" "qa_rqw_server" {
#  name          = "qa_rqw_server"
#  image_id      = "${lookup(var.rts_amis, "qaserver")}"
  image_id      = "${var.qa_rqw_server_ami}"
  instance_type = "${var.instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.qa_rqw_server_profile.name}"

  # Security group
  security_groups = ["${aws_security_group.qa_rqw_server.id}"]
  user_data       = "${file("qa/userdata.sh")}"
  key_name        = "${var.key_name}"
  lifecycle {
        create_before_destroy = true
  }
}

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "qa_rqw_server" {
  name        = "qa_rqw_server"
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

  # WLS API access from anywhere
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["172.0.0.0/8"]
  }

  # WLS PROXYaccess from anywhere
  ingress {
    from_port   = 8080
    to_port     = 8080
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
