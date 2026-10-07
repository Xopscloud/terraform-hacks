Modules

A module is a reusable collection of Terraform configuration.

This is one of the most important Terraform concepts.

Imagine you create an EC2 server.

You might have:

main.tf
variables.tf
outputs.tf

Now suppose you need 10 EC2 servers.

Instead of copying the same code 10 times, you can create a module and reuse it.

Basic Module Structure

Suppose we have:

terraform-project/
│
├── main.tf
├── variables.tf
├── outputs.tf
│
└── modules/
    └── ec2/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf

The ec2 directory is our module.

Creating the EC2 Module
modules/ec2/main.tf
resource "aws_instance" "this" {

  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = var.name
  }
}
modules/ec2/variables.tf
variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "name" {
  type = string
}
modules/ec2/outputs.tf
output "instance_id" {
  value = aws_instance.this.id
}

output "public_ip" {
  value = aws_instance.this.public_ip
}

Now we have created a reusable EC2 module.

Using the Module

In the root main.tf:

module "web_server" {

  source = "./modules/ec2"

  ami_id        = "ami-0123456789abcdef0"
  instance_type = "t2.micro"
  name          = "web-server"
}

Terraform sees:

root module
     │
     ▼
module "web_server"
     │
     ▼
modules/ec2
     │
     ├── resource
     ├── variables
     └── outputs
Getting Output From a Module

Remember that our module has:

output "public_ip" {
  value = aws_instance.this.public_ip
}

The root module can access it:

output "web_server_ip" {
  value = module.web_server.public_ip
}

After:

terraform apply

you might get:

web_server_ip = "54.123.45.67"
Using the Same Module Multiple Times

This is where modules become powerful.

You can create:

module "web_server" {

  source = "./modules/ec2"

  ami_id        = "ami-0123456789abcdef0"
  instance_type = "t2.micro"
  name          = "web-server"
}

And another:

module "database_server" {

  source = "./modules/ec2"

  ami_id        = "ami-0123456789abcdef0"
  instance_type = "t3.medium"
  name          = "database-server"
}

Same module:

             modules/ec2
                 │
       ┌─────────┴─────────┐
       ↓                   ↓
 web_server          database_server
 t2.micro             t3.medium

You don't have to duplicate the EC2 resource code.