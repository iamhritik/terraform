#scenario-1 -> create a resource block and use local-exec provisioner to copy private-ips into local file.
resource "aws_instance" "web-instances" {
  count                  = 2
  ami                    = "ami-006d3995d3a6b963b"
  instance_type          = "t2.micro"
  key_name               = "ttn"
  subnet_id              = "subnet-01a2927ff29ebfbb8"
  vpc_security_group_ids = ["sg-0a8554057bfdb46a9"]
  availability_zone      = "ap-south-1b"

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_size           = 10
    volume_type           = "gp3"
    tags = {
      Name = "web-server-root-vol"
    }
  }
  tags = {
    Name       = "web-instance-${count.index}"
    managed_by = "terraform-managed"
  }
  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"
    when = destroy
  }

}

#scenario2 -> use file provisioner to copy script on remote host and then used triggers to execute that script.
resource "aws_instance" "web-instances" {
  count                  = 2
  ami                    = "ami-006d3995d3a6b963b"
  instance_type          = "t2.micro"
  key_name               = "ttn"
  subnet_id              = "subnet-01a2927ff29ebfbb8"
  vpc_security_group_ids = ["sg-0a8554057bfdb46a9"]
  availability_zone      = "ap-south-1b"

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_size           = 10
    volume_type           = "gp3"
    tags = {
      Name = "web-server-root-vol"
    }
  }
  tags = {
    Name       = "web-instance-${count.index}"
    managed_by = "terraform-managed"
  }
  connection {
    type = "ssh"
    user = "ubuntu"
    host = "${self.public_ip}"
    private_key = file("ttn.pem")
  }
  provisioner "file" {
    source = "test.sh"
    destination = "/home/ubuntu/test.sh"
  }

}

resource "null_resource" "web-instance" {
    count = 2
    triggers = {
        instances = "${join(",", aws_instance.web-instances.*.id)}"
    }
    connection {
        type = "ssh"
        user = "ubuntu"
        host = "${element(aws_instance.web-instances.*.public_ip, count.index)}"
        private_key = file("ttn.pem")
    }
    provisioner "remote-exec" {
        inline = [
            "chmod +x /home/ubuntu/test.sh",
            "/home/ubuntu/test.sh"
        ]
    }
}