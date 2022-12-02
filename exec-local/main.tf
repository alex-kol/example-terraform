provider "aws" {
  region = "eu-west-1"
}

resource "null_resource" "cmd1" {
  provisioner "local-exec" {
    command = "echo Terrafform start: $(date) >> log.txt"
  }
}

resource "null_resource" "cmd2" {
  provisioner "local-exec" {
    command = "ping -c 5 www.google.com"
  }
}

resource "null_resource" "cmd3" {
  provisioner "local-exec" {
    command = "print('Hello')"
    interpreter = [
      "python",
      "-c"
    ]
  }
}

resource "null_resource" "cmd4" {
  provisioner "local-exec" {
    command = "echo $NAME $Enviropment >> log.txt"
    environment = {
      NAME        = "Alex",
      Enviropment = "Prod"
    }
  }
}


resource "null_resource" "cmd5" {
  provisioner "local-exec" {
    command = "echo Terrafform end: $(date) >> log.txt"
  }
}
