# -------------------------
# Outputs
# -------------------------

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.my_instance.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.my_instance.public_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.my_instance.public_dns
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.my_security_sg.id
}

output "website_url" {
  description = "HTTP URL of the Apache website"
  value       = "http://${aws_instance.my_instance.public_ip}"
}
