resource aws_elb bastion {
  name            = var.name
  security_groups = var.security_groups
  subnets         = flatten([var.subnet_ids])
  idle_timeout    = 3600

  listener {
    instance_port     = "22"
    instance_protocol = "tcp"
    lb_port           = var.port
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:22"
    interval            = 15
  }

  tags = {
    Name        = "${var.name}-elb"
    Environment = var.environment
  }
}

resource aws_launch_configuration bastion {
  name_prefix                 = "${var.name}-"
  image_id                    = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  security_groups             = var.security_groups
  user_data                   = data.template_file.bastion.rendered
  associate_public_ip_address = true

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "20"
    delete_on_termination = true
    encrypted             = true
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [image_id]
  }
}

resource aws_autoscaling_group bastion {
  name                 = var.name
  max_size             = "1"
  min_size             = "1"
  vpc_zone_identifier  = flatten([var.subnet_ids])
  launch_configuration = aws_launch_configuration.bastion.name
  desired_capacity     = "1"
  load_balancers       = [aws_elb.bastion.id]

  tag {
    key                 = "Name"
    value               = var.name
    propagate_at_launch = true
  }

}

data aws_route53_zone zone {
  name         = "${var.domain}."
  private_zone = false
}

resource aws_route53_record bastion {
  zone_id        = data.aws_route53_zone.zone.id
  name           = "bastion.${var.domain}"
  type           = "CNAME"
  ttl            = "60"
  set_identifier = var.name
  records        = [aws_elb.bastion.dns_name]

  weighted_routing_policy {
    weight = 10
  }

  depends_on = [aws_elb.bastion]

}
