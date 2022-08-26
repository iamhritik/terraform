resource "aws_launch_template" "eks-nodegroup-template" {
  name = "demo-launch-template"
  image_id                             = "ami-05c200ff7ef5b2583"
  instance_type                        = "t3.medium"
  key_name                             = "ttn"
  vpc_security_group_ids = ["${aws_security_group.sg2.id}"]

  block_device_mappings {
    device_name = "/dev/xvda"

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

  user_data = base64encode(<<-EOF
  MIME-Version: 1.0
  Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="
  --==MYBOUNDARY==
  Content-Type: text/x-shellscript; charset="us-ascii"
  #!/bin/bash
  /etc/eks/bootstrap.sh ${var.cluster_name}
  --==MYBOUNDARY==--\
    EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name  = "${var.cluster_name}-Node_groups-Instances"
      owner = "terraform-managed"
      demo-launch-template-instances = "yes"
    }
  }

}