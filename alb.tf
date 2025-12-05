# Application Load Balancer in two public subnets (two AZs required)
resource "aws_lb" "app" {
  name               = "${var.prefix}-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public1.id, aws_subnet.public2.id]

  tags = merge(local.common_tags, { Name = "${var.prefix}-alb" })
}

resource "aws_lb_target_group" "app_tg" {
  name     = "${var.prefix}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.this.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(local.common_tags, { Name = "${var.prefix}-tg" })
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}