variable "ec2_name" {
    type = string
    default     = "webserver-1"
}

resource "aws_instance" "instance1" {
  ami                    = "ami-006d3995d3a6b963b"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-01a2927ff29ebfbb8"
  key_name               = "ttn"
  availability_zone      = "ap-south-1b"
  vpc_security_group_ids = ["sg-0edde130a81dec1b9"]

  root_block_device {
    delete_on_termination = true
    volume_type           = "gp3"
    volume_size           = "10"
    tags = {
      Name = "${var.ec2_name}-root-vol"
    }

  }
  tags = {
    Name       = "${var.ec2_name}"
    managed_by = "terraform"
  }
  user_data = base64encode(<<-EOF
    MIME-Version: 1.0
    Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="
    --==MYBOUNDARY==
    Content-Type: text/x-shellscript; charset="us-ascii"
    #!/bin/bash
    sudo apt update -y
    sudo apt install apache2 -y
    sudo systemctl status apache2
    --==MYBOUNDARY==--\
    EOF
  )
}