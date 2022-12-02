variable "region" {
  description = "AWS Region"
  type        = string # default type
  default     = "eu-west-1"
}

variable "ec2_type" {
  description = "EC2 type for deploy"
  default     = "t2.micro"
}

variable "allow_ports" {
  description = "Port 80 for Listener"
  type        = list(any)
  default     = ["80", "443", "22"]
}

variable "listener_port" {
  default = 80
}

variable "cidr_blocks" {
  default = ["0.0.0.0/0", "10.10.10.0/24"]
}

variable "common_tags" {
  description = "Common tags to apply to all resourses"
  type        = map(any)
  default = {
    Name        = "WebServer"
    Owner       = "Alex"
    CostCenter  = "Krop"
    Enviropment = "Production"
  }
}

