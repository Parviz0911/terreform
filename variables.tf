# Created by Parviz

provider "aws" {
  region = "us-east-1"
}

# Get the latest Ubuntu 20.04 AMI ID
data "aws_ami" "latest_ubuntu" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

# EC2 Instance Resource
resource "aws_instance" "web" {
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = var.instance_type

  tags = {
    Name = "TerraformEC2"
  }
}
