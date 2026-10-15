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
  type    = string
  default = "terraform-sg"
}

variable "security_group_description" {
  type    = string
  default = "This security group is for Terraform"
}

variable "ami_id" {
  type    = string
  default = "ami-0f8a61b66d1accaee"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "key_name" {
  type    = string
  default = "terra-css"
}

variable "instance_tag" {
  type    = string
  default = "HelloWorld"
}

variable "allowed_cidr" {
  description = "CIDR range allowed to access HTTP and HTTPS"
  type        = string
  default     = "0.0.0.0/0"
}

variable "ssh_cidr" {
  description = "CIDR range allowed to access SSH"
  type        = string
  default     = "0.0.0.0/0"
}

variable "http_port" {
  type    = number
  default = 80
}

variable "ssh_port" {
  type    = number
  default = 22
}

variable "https_port" {
  type    = number
  default = 443
}

# -------------------------
# Local Values
# -------------------------

locals {
  security_group_tag = "terra"

  common_tags = {
    ManagedBy = "Terraform"
    Project   = "WebServer"
  }

  apache_user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    systemctl enable --now apache2
    echo "The page was created by user data" > /var/www/html/index.html
  EOF
}

# -------------------------
# Security Group
# -------------------------

resource "aws_security_group" "my_security_sg" {
  name        = var.security_group_name
  description = var.security_group_description

  tags = merge(local.common_tags, {
    Name = local.security_group_tag
  })
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

  user_data = local.apache_user_data

  tags = merge(local.common_tags, {
    Name = var.instance_tag
  })
}
