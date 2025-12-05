output "alb_dns_name" {
  description = "Public URL of the ALB"
  value       = aws_lb.app.dns_name
}

output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = [aws_subnet.public1.id, aws_subnet.public2.id]
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

output "asg_name" {
  value = aws_autoscaling_group.app.name
}