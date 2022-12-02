data template_file ecs_instance {
  template = file("${path.module}/files/ecs_instance.sh.tpl")
  vars = {
    cluster_name      = var.name
    # newrelic_lic_key  = var.newrelic_lic_key
  }
}

resource aws_launch_configuration ecs_instance {
  name_prefix                 = "${var.name}-ecs-"
  image_id                    = var.image_id
  instance_type               = var.instance_type
  iam_instance_profile        = var.iam_instance_profile
  key_name                    = var.key_name
  user_data                   = data.template_file.ecs_instance.rendered
  associate_public_ip_address = var.associate_public_ip_address
  spot_price                  = var.spot_price
  security_groups             = var.security_groups

  root_block_device {
    volume_type           = var.volume_type
    volume_size           = var.volume_size
    iops                  = var.iops
    delete_on_termination = true
    encrypted             = true
  }
}
