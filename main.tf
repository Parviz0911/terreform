terraform {
  required_providers {
    aws = {
      region = "us-east-2"
      source = "hashicorp/aws"
      version = "5.88.0"
    }
  }
}

provider "aws" {}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

locals { # local expressions
  image_id = data.aws_ami.ubuntu.id
}

variable "prefix" { # Input variables
  default = "dev"
}

variable "instance_type" { # Input variables
  default = "t2.micro"
}


# resource_type = aws_instance
# resource logical_name = server
# resource_address = aws_instance.server
resource "aws_instance" "server" {
  ami           = local.image_id
  instance_type = var.instance_type

  tags = {
    Name = var.prefix
  }
}


#  TERRAFORM BACKEND

## CONFIGURATION FILE
output "ubuntu_image_id" {
  value = local.image_id
}

# Terraform Configuration Blocks
# 1. terraform block
# 2. provider block
# 3. resource block >>> Create / Modify / Delete
# 4. data block >>> Read from a source
# 5. variable block / input
# 6. local block
# 7. module block > not now
# 8. output block


# my_family:
#   mom_and_dad:
#     children_1:
#       name:
#       age:
#       occupation:
#     children_2:
#       name:
#       age:
#       occupation:
#     children_3:
#       name:
#       age:
#       occupation:
#     children_4:
#       name:
#       age:
#       occupation:



## Object Oriented Language
# pizza:
#    size: 12"
#     white_sauce:
#       pepperoni:
#     red_sauce:
#       mushroom:
#       pepperoni:

# yaml
# json
