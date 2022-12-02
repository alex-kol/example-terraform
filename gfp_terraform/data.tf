data aws_ami amazon-ami {
  most_recent = true
  filter {
    name = "name"
    values = [ "amzn2-ami-ecs-hvm-2.0.*-x86_64-ebs"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
  owners = ["amazon"]
}
