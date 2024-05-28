provider "aws" {
  region = "us-east-1"  # Specify your region here
}

variable "env" {
  description = "Environment for which resources will be created (e.g., dev, prod)"
  type        = string
  default = "dev"
}


# Local block for environment-specific configurations
locals {
  environment_configurations = {
    "dev" = {
      instance_type = "t2.micro"
      vpc_id          = "vpc-0709a0e29954aba34"
      ami_id        = "ami-0bb84b8ffd87024d8"
      tags = {
        Name        = "example-instance"
        Environment = var.env
      }
      security_group_name = "dev-sg"
      security_group_description = "Security group for development environment"
      security_group_ingress = [
        {
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    }
    "prod" = {
      instance_type = "t3.medium"
      ami_id        = "ami-0bb84b8ffd87024d8"
      tags = {
        Name        = "example-instance"
        Environment = "production"
      }
      security_group_name = "prod-sg"
      security_group_description = "Security group for production environment"
      security_group_ingress = [
        {
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    }
  }

  config = local.environment_configurations[var.env]
}



# Create Security Group
resource "aws_security_group" "instance_sg" {
  name        = local.config.security_group_name
  description = local.config.security_group_description
  vpc_id      = local.config.vpc_id  # Replace with your VPC ID

  dynamic "ingress" {
    for_each = local.config.security_group_ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}

module "ec2_instance" {
  source = "../ec2-infra"  # Path to your module directory
  ami_id          = local.config.ami_id
  instance_type = local.config.instance_type
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  tags = local.config.tags
}

output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = module.ec2_instance.instance_id
}

output "instance_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = module.ec2_instance.instance_public_ip
}
