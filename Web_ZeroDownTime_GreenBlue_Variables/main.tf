# -------------------------------------------------
# Usage VPC / Autoscaling / Zero Downtime
# -------------------------------------------------

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# -------------------------------------------------
# Security group
# -------------------------------------------------
resource "aws_security_group" "web" {
  name = "Dynamic SG"

  dynamic "ingress" {
    for_each = var.allow_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.cidr_blocks
    }
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  tags = merge(var.common_tags, { Name = "${var.common_tags["Enviropment"]}" }, { Region = var.region })

}

# -------------------------------------------------
# Launch configuration
# -------------------------------------------------

resource "aws_launch_configuration" "web" {
  # name            = "WebServer-Highly-Available-LC"
  name_prefix     = "WebServer-Highly-Available-ASG"
  image_id        = data.aws_ami.ubuntu.id
  instance_type   = var.ec2_type
  security_groups = [aws_security_group.web.id]
  user_data       = file("./file/user_data.sh")

  lifecycle {
    create_before_destroy = true
  }

}

# -------------------------------------------------
# Autoscaling Group
# -------------------------------------------------

resource "aws_autoscaling_group" "web" {
  name                 = "ASG-${aws_launch_configuration.web.name}"
  launch_configuration = aws_launch_configuration.web.name
  max_size             = 2
  min_size             = 2
  min_elb_capacity     = 2
  health_check_type    = "ELB"
  load_balancers       = [aws_elb.web.name]
  vpc_zone_identifier  = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]

  dynamic "tag" {
    for_each = {
      Name   = "WebServer ASG"
      Owner  = "Alex"
      TAGKEY = "TAGVALUE"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true

    }
  }

  lifecycle {
    create_before_destroy = true
  }

}

# -------------------------------------------------
# ELB
# -------------------------------------------------

resource "aws_elb" "web" {
  name               = "WebServer-HA-ELB"
  availability_zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  security_groups    = [aws_security_group.web.id]

  listener {
    lb_port           = var.listener_port
    lb_protocol       = "http"
    instance_port     = var.listener_port
    instance_protocol = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 10
  }

  tags = merge(var.common_tags, { Name = "${var.common_tags["Enviropment"]}" }, { Region = var.region })

}

# -------------------------------------------------
# Default VPC
# -------------------------------------------------

resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.available.names[1]
}

# -------------------------------------------------
# TEsting tags, on example EIP
# -------------------------------------------------
# data "aws_region" "current" {}
# data "aws_availability_zones" "avai_lable" {}

# locals {
#   full_project_name = "${var.common_tags.Enviropment}-${var.common_tags.Owner}"
#   project_owner     = "${var.common_tags.Name}-${var.common_tags.Owner}"
#   az_list = join("/",data.aws_availability_zones.avai_lable.names)
#   region_list = data.aws_region.current.id
# }

# resource "aws_eip" "test_tags" {
#   tags = {
#     Name        = "ALC-Web"
#     Common_Tags = local.full_project_name
#     Owner       = local.project_owner
#     region_list = local.az_list
#     region_current = local.region_list
#   }
# }
