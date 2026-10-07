terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.67.0"
    }
  }
}

provider "aws" {
  # Configuration options
}

resource "aws_instance" "example" {
  ami           = "ami-0f8a61b66d1accaee"
  instance_type = "t3.micro"

  tags = {
    Name = "HelloWorld"
  }
}
