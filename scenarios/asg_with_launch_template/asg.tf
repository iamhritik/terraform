resource "aws_autoscaling_group" "demo-asg" {
  desired_capacity          = 1
  max_size                  = 1
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  vpc_zone_identifier       = ["${aws_subnet.public_subnet1.id}","${aws_subnet.public_subnet2.id}"]

  launch_template {
    id      = aws_launch_template.demo-template.id
    version = "$Latest"
  }

  target_group_arns = ["${aws_lb_target_group.demo-tg.arn}"]
  tag {
    key                 = "Name"
    value               = "demo-asg"
    propagate_at_launch = true
  }
}