# Latest Amazon Linux 2 AMI
data "aws_ami" "amzn2" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_launch_template" "app" {
  name_prefix   = "${var.prefix}-lt-"
  image_id      = data.aws_ami.amzn2.id
  instance_type = var.instance_type

  # Attach app SG; in public subnets we rely on map_public_ip_on_launch for public IP
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  # Apache + branded HTML
  user_data = filebase64("${path.module}/userdata.sh")

  tag_specifications {
    resource_type = "instance"
    tags = merge(local.common_tags, { Name = "${var.prefix}-web" })
  }

  tag_specifications {
    resource_type = "volume"
    tags          = local.common_tags
  }

  tags = merge(local.common_tags, { Name = "${var.prefix}-lt" })
}