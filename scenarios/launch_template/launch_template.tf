resource "aws_launch_template" "demo-template" {
  name = "demo-launch-template"

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 10
      volume_type = "gp3"
      encrypted   = true
    }
  }
  iam_instance_profile {
    arn = "arn:aws:iam::766418871530:instance-profile/ec2-role-Instance-Profile"
  }

  image_id                             = "ami-006d3995d3a6b963b"
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = "t2.micro"
  key_name                             = "ttn"
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }
  placement {
    availability_zone = "ap-south-1a"
  }
  vpc_security_group_ids = ["sg-0edde130a81dec1b9"]
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name  = "demo-launch-template-instances"
      owner = "terraform-managed"
    }
  }

  user_data = filebase64("${path.module}/userdata.sh")
}