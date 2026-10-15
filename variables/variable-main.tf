terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.67.0"
    }
  }
}

provider "aws" {
  # Uses AWS CLI credentials or an IAM role
}

# -------------------------
# Input Variables
# -------------------------

variable "security_group_name" {
  description = "Name of the security group"
  type        = string
  default     = "terraform-sg"
}

variable "security_group_description" {
  description = "Description of the security group"
  type        = string
  default     = "This security group is for Terraform"
}

variable "security_group_tag" {
  description = "Security group Name tag"
  type        = string
  default     = "terra"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0f8a61b66d1accaee"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Existing AWS EC2 key pair name"
  type        = string
  default     = "terra-css"
}

variable "instance_tag" {
  description = "EC2 instance Name tag"
  type        = string
  default     = "HelloWorld"
}

variable "http_port" {
  description = "HTTP port"
  type        = number
  default     = 80
}

variable "ssh_port" {
  description = "SSH port"
  type        = number
  default     = 22
}

variable "https_port" {
  description = "HTTPS port"
  type        = number
  default     = 443
}

variable "allowed_cidr" {
  description = "CIDR range allowed to access web ports"
  type        = string
  default     = "0.0.0.0/0"
}

variable "ssh_cidr" {
  description = "CIDR range allowed to access SSH"
  type        = string
  default     = "0.0.0.0/0"
}

# -------------------------
# Security Group
# -------------------------

resource "aws_security_group" "my_security_sg" {
  name        = var.security_group_name
  description = var.security_group_description

  tags = {
    Name = var.security_group_tag
  }
}

# HTTP
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.my_security_sg.id
  cidr_ipv4         = var.allowed_cidr
  from_port         = var.http_port
  ip_protocol       = "tcp"
  to_port           = var.http_port
}

# SSH
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.my_security_sg.id
  cidr_ipv4         = var.ssh_cidr
  from_port         = var.ssh_port
  ip_protocol       = "tcp"
  to_port           = var.ssh_port
}

# HTTPS
resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.my_security_sg.id
  cidr_ipv4         = var.allowed_cidr
  from_port         = var.https_port
  ip_protocol       = "tcp"
  to_port           = var.https_port
}

# Outbound traffic
resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.my_security_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# -------------------------
# EC2 Instance
# -------------------------

resource "aws_instance" "my_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.my_security_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    systemctl enable --now apache2
    echo "The page was created by user data" > /var/www/html/index.html
  EOF

  tags = {
    Name = var.instance_tag
  }
}
