Local Values

A local value is a value that you define inside your Terraform configuration and reuse multiple times.

Think of it as a variable that is intended for internal use within the module.

Syntax:

locals {
  name = "value"
}

You access it using:

local.name
Example
locals {
  project_name = "my-web-app"
  environment  = "production"
}

You can use these values in resources:

resource "aws_instance" "example" {

  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name        = local.project_name
    Environment = local.environment
  }
}

The EC2 tags become:

Name        = my-web-app
Environment = production
Variables vs Locals

This distinction is important:

Input Variable	Local Value
Input from user/outside	Internal value
Can be changed by caller	Defined by configuration
var.name	local.name
Used to customize Terraform	Used to simplify/reuse Terraform
Simple way to remember
Variable = What do I want to give Terraform?

Local = What value do I want to calculate/reuse inside Terraform?

For example:

variable "environment" {
  default = "dev"
}

locals {
  instance_name = "myapp-${var.environment}"
}

Then:

local.instance_name

produces:

myapp-dev