How All Four Work Together

This is the most important part.

Imagine:

variables.tf
variable "environment" {
  type    = string
  default = "dev"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}
locals.tf
locals {
  project_name = "myapp"
  server_name  = "${local.project_name}-${var.environment}"
}
main.tf
resource "aws_instance" "example" {

  ami           = "ami-0123456789abcdef0"
  instance_type = var.instance_type

  tags = {
    Name = local.server_name
  }
}
outputs.tf
output "instance_id" {
  value = aws_instance.example.id
}

output "public_ip" {
  value = aws_instance.example.public_ip
}

The flow is:

              INPUT
                │
                ▼
        ┌───────────────┐
        │   Variables   │
        │  var.xxx      │
        └───────┬───────┘
                │
                ▼
        ┌───────────────┐
        │     Locals    │
        │  local.xxx    │
        └───────┬───────┘
                │
                ▼
        ┌───────────────┐
        │   Resources   │
        │ aws_instance  │
        └───────┬───────┘
                │
                ▼
        ┌───────────────┐
        │    Outputs    │
        │ output "xxx"  │
        └───────────────┘
                │
                ▼
             RESULT