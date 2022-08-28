variable "instance_count" {
  description = "EC2 instance count"
  type        = number
  default     = 1
}

resource "aws_instance" "instance1" {
  count         = var.instance_count
  ami           = "ami-006d3995d3a6b963b"
  instance_type = "t2.micro"

  tags = {
    Name = "test-server-${count.index}"
    #it will show the instance name like this: test-server-0 i.e not good
  }
}

output "public_ip" {
    description = "Instance Public IP"
    value = ["${aws_instance.instance1.*.public_ip}"]
}

