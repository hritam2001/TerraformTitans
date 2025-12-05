# ALB SG: allow HTTP from anywhere
resource "aws_security_group" "alb_sg" {
  name        = "${var.prefix}-alb-sg"
  description = "ALB security group"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${var.prefix}-alb-sg" })
}

# App SG: allow HTTP only from ALB
resource "aws_security_group" "app_sg" {
  name        = "${var.prefix}-app-sg"
  description = "App instance SG"
  vpc_id      = aws_vpc.this.id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    description = "All egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${var.prefix}-app-sg" })
}