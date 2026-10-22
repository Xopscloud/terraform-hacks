variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
  default     = "ami-0f8a61b66d1accaee"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Name of EC2 instance"
  type        = string
  default     = "Terraform-Module-EC2"
}