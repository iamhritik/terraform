resource "aws_launch_template" "eks-nodegroup-template" {
  name = "demo-launch-template"
  image_id                             = "ami-006d3995d3a6b963b"
  instance_type                        = "t2.micro"
  key_name                             = "ttn"
  vpc_security_group_ids = ["${aws_security_group.sg2.id}"]

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 10
      volume_type = "gp3"
      encrypted   = true
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name  = "demo-launch-template-instances"
      owner = "terraform-managed"
    }
  }

  user_data = filebase64("${path.module}/userdata.sh")
}