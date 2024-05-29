provider "aws" {
  region = "us-east-1"
}

variable "env" {
  description = "Environment for which resources will be created (e.g., dev, prod)"
  type        = string
  default     = "dev"
}



variable "db_username_ssm_parameter" {
  description = "The SSM parameter name for the database username"
  type        = string
  default     = "/rds/db_name"
}

variable "db_password_ssm_parameter" {
  description = "The SSM parameter name for the database password"
  type        = string
  default     = "/rds/db_password"
}

data "aws_ssm_parameter" "db_username" {
  name = var.db_username_ssm_parameter
}

data "aws_ssm_parameter" "db_password" {
  name            = var.db_password_ssm_parameter
  with_decryption = true

}




locals {
  environment_configurations = {
    "dev" = {
      env                                   = "dev"
      vpc_id                                = "vpc-0ab1923d70753d8d4"
      db_name                               = "mydatabase"
      db_instance_class                     = "db.t3.micro"
      allocated_storage                     = 20
      max_allocated_storage                 = 100
      db_subnet_group_name                  = "default"
      username                              = data.aws_ssm_parameter.db_username.value
      password                              = data.aws_ssm_parameter.db_password.value
      multi_az                              = false
      storage_type                          = "gp2"
      backup_retention_period               = 7
      maintenance_window                    = "Sun:00:00-Sun:03:00"
      backup_window                         = "03:00-06:00"
      storage_encrypted                     = true
      kms_key_id                            = null
      copy_tags_to_snapshot                 = true
      performance_insights_enabled          = true
      performance_insights_kms_key_id       = "arn:aws:kms:us-east-1:426765591064:key/5e4ec07e-36d7-4d13-a690-c43a0cb8b8d4"
      performance_insights_retention_period = 7
      tags = {
        Environment = "dev"
        Project     = "MyApp"
        Name        = "My testing"
      }

      security_group_name        = "dev-sg-1"
      security_group_description = "Security group for development environment"
      security_group_ingress = [
        {
          from_port   = 443
          to_port     = 443
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
      security_group_name        = "prod-sg"
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

resource "aws_security_group" "instance_sg" {
  name        = local.config.security_group_name
  description = local.config.security_group_description
  vpc_id      = local.config.vpc_id

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



module "rds_postgresql" {
  source                                = "../../module/postgressmodule"
  db_name                               = local.config.db_name
  db_instance_class                     = local.config.db_instance_class
  allocated_storage                     = local.config.allocated_storage
  max_allocated_storage                 = local.config.max_allocated_storage
  db_subnet_group_name                  = local.config.db_subnet_group_name
  username                              = local.config.username
  password                              = local.config.password
  multi_az                              = local.config.multi_az
  storage_type                          = local.config.storage_type
  backup_retention_period               = local.config.backup_retention_period
  maintenance_window                    = local.config.maintenance_window
  backup_window                         = local.config.backup_window
  vpc_security_group_ids                = [aws_security_group.instance_sg.id]
  storage_encrypted                     = local.config.storage_encrypted
  kms_key_id                            = local.config.kms_key_id
  copy_tags_to_snapshot                 = local.config.copy_tags_to_snapshot
  performance_insights_enabled          = local.config.performance_insights_enabled
  performance_insights_kms_key_id       = local.config.performance_insights_kms_key_id
  performance_insights_retention_period = local.config.performance_insights_retention_period
  tags                                  = local.config.tags
}

output "db_instance_id" {
  value = module.rds_postgresql.db_instance_id
}

output "db_instance_endpoint" {
  value = module.rds_postgresql.db_instance_endpoint
}

output "db_instance_arn" {
  value = module.rds_postgresql.db_instance_arn
}

output "db_instance_address" {
  value = module.rds_postgresql.db_instance_address
}

output "db_instance_status" {
  value = module.rds_postgresql.db_instance_status
}
