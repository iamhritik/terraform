resource "aws_instance" "instance1" {
  ami                    = "ami-098247d860bd88c63"
  instance_type          = "t4g.small"
  key_name               = "ttn"
  subnet_id              = "subnet-01a2927ff29ebfbb8"
  vpc_security_group_ids = ["sg-0edde130a81dec1b9"]
  availability_zone      = "ap-south-1b"

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_size           = 10
    volume_type           = "gp3"
  }

  tags = {
    Name       = "taint1-instance"
    managed_by = "terraform-managed"
  }

}

resource "aws_instance" "instance2" {
  ami                    = "ami-098247d860bd88c63"
  instance_type          = "t4g.small"
  key_name               = "ttn"
  subnet_id              = "subnet-01a2927ff29ebfbb8"
  vpc_security_group_ids = ["sg-0edde130a81dec1b9"]
  availability_zone      = "ap-south-1b"

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_size           = 10
    volume_type           = "gp3"
  }

  tags = {
    Name       = "taint2-instance"
    managed_by = "terraform-managed"
  }

}
