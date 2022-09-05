# variable "instance_type" {
#   description = "EC2 instance type"
#   type        = string
# }

# resource "aws_instance" "instance1" {
#   count         = format("%.2s", var.instance_type) == "t2" ? 1 : 0
#   ami           = "ami-006d3995d3a6b963b"
#   instance_type = var.instance_type

#   tags = {
#     Name = "test-server-${count.index}"
#     #it will show the instance name like this: test-server-0 i.e not good
#   }
# }

##########
resource "aws_instance" "instance2" {
  ami           = "ami-06489866022e12a14"
  key_name = "ttn"
  instance_type = "t3.micro"

  tags = {
    Name = "test-server2-"
    #it will show the instance name like this: test-server-0 i.e not good
  }
  lifecycle {
    create_before_destroy = true
  }
}

output "ec2_all" {
  description = "EC2 instance details"
  value       = ["${aws_instance.instance2.*}"]
}


# resource "time_sleep" "wait_30_seconds" {
#   create_duration = "120s"
#   triggers = {
#     public_ip = aws_instance.instance2.public_ip
#   }
# }