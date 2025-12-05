# ASG places instances in the TWO PUBLIC subnets (no NAT used)
resource "aws_autoscaling_group" "app" {
  name                      = "${var.prefix}-asg"
  desired_capacity          = var.desired_capacity
  min_size                  = var.min_size
  max_size                  = var.max_size
  vpc_zone_identifier       = [aws_subnet.public1.id, aws_subnet.public2.id]

  health_check_type         = "ELB"
  health_check_grace_period = 60

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.app_tg.arn]

  tag {
    key                 = "Name"
    value               = "${var.prefix}-web"
    propagate_at_launch = true
  }

  depends_on = [aws_lb_listener.http]
}