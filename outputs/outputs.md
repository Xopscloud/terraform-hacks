Outputs

An output allows Terraform to show or expose information after infrastructure is created.

For example, after creating an EC2 instance, you may want to know:

Public IP
Private IP
Instance ID
DNS name

Instead of manually searching for these values in AWS, use outputs.

Example
outputs.tf
output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.example.id
}

Another output:

output "public_ip" {
  description = "EC2 public IP address"
  value       = aws_instance.example.public_ip
}

Run:

terraform apply

Terraform may show:

Outputs:

instance_id = "i-0123456789abcdef"
public_ip   = "54.123.45.67"

You can also get a specific output:

terraform output public_ip