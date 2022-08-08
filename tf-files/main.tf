#create a security group
resource "aws_security_group" "sg1"{
  name = "provisioner-tes-sg"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#create a PEM formatted private key
resource "tls_private_key" "rsa1"{
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "key1"{
  key_name = "provisioner"
  public_key = tls_private_key.rsa1.public_key_openssh
}

resource "aws_instance" "instance1"{
  ami = "ami-006d3995d3a6b963b"
  instance_type = "t2.micro"
  vpc_security_group_ids  = [aws_security_group.sg1.id]
  key_name = aws_key_pair.key1.key_name

  connection {
    type = "ssh"
    host = self.public_ip
    user = "ubuntu"
    private_key = tls_private_key.rsa1.private_key_pem
  }

  provisioner "remote-exec"{
    inline = [
      "echo \"Hello, World from $(uname -smp)\"",
      "touch test"
    ]
  }
}