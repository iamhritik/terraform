#scenario2 -> use file provisioner to copy script on remote host and then used triggers to execute that script.
resource "aws_instance" "web-instances" {
  count                  = 2
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  availability_zone      = var.az

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_size           = var.volume_size
    volume_type           = var.volume_type
    tags = {
      Name = "web-server-root-vol"
    }
  }
  tags = {
    Name       = "web-instance-${count.index}"
    managed_by = "terraform-managed"
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
        private_key = file("ssh.pem")
    }
    provisioner "remote-exec" {
        script = "./test.sh"
    }
}