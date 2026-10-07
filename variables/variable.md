# Terraform reads variable from

terraform.tfvars
       ↓
variable
       ↓
var.instance_type
       ↓
EC2 resource


<!-- ## There are several ways to provide a variable. -->

# Method 1 — terraform.tfvars

instance_type = "t2.micro"

# Method 2 — Default value

<!-- You can put the default directly in variables.tf: -->

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

Then you don't need terraform.tfvars.

# Method 3 — Command line

terraform plan -var="instance_type=t3.micro"
Method 4 — Environment variable

Terraform also supports:

export TF_VAR_instance_type="t3.micro"

# Why do people use both?

Because it separates definition from configuration.

For example:

variables.tf
variable "instance_type" {
  type = string
}

variable "environment" {
  type = string
}

variable "project_name" {
  type = string
}

This defines your inputs.

Then:

terraform.tfvars
instance_type = "t3.micro"
environment   = "production"
project_name  = "my-web-app"

This contains your configuration.

Your main.tf stays clean:

resource "aws_instance" "example" {
  ami           = "ami-xxxxxxxx"
  instance_type = var.instance_type

  tags = {
    Name        = var.project_name
    Environment = var.environment
  }
}

So you can change:

environment = "production"

to:

environment = "development"

without changing your infrastructure code.

One important point

Terraform automatically loads:

terraform.tfvars

and also files ending in:

.auto.tfvars

So if you create:

dev.tfvars

Terraform does not automatically load it.

You would need:

terraform plan -var-file="dev.tfvars"

This becomes very useful when you have:

dev.tfvars
prod.tfvars

For example:

terraform plan -var-file="dev.tfvars"

or:

terraform plan -var-file="prod.tfvars"
Easy rule to remember
variables.tf
     ↓
"What variables exist?"

terraform.tfvars
     ↓
"What values should they have?"

main.tf
     ↓
"How should those values be used?"

So variables.tf = definition, terraform.tfvars = values, and main.tf = usage.