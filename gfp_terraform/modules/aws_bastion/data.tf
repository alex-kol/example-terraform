data aws_ami ubuntu {
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

data template_file bastion {
  template = file("${path.module}/files/bastion_config.sh.tpl")
  vars = {
    data_ssh                      = var.data_ssh
    environment                   = var.environment
    region                        = var.region
    name                          = var.name
  }
}
