


resource "aws_db_instance" "postgresql" {
  allocated_storage              = var.allocated_storage
  max_allocated_storage          = var.max_allocated_storage
  instance_class                 = var.db_instance_class
  engine                         = "postgres"
  engine_version                 = "16.2"  
  db_name                          = var.db_name
  username                       = var.username 
  password                       = var.password 
  db_subnet_group_name           = var.db_subnet_group_name
  multi_az                       = var.multi_az
  storage_type                   = var.storage_type
  backup_retention_period        = var.backup_retention_period
  maintenance_window             = var.maintenance_window
  backup_window                  = var.backup_window
  storage_encrypted              = var.storage_encrypted
  kms_key_id                     = var.kms_key_id
  vpc_security_group_ids         = var.vpc_security_group_ids  
  copy_tags_to_snapshot          = var.copy_tags_to_snapshot
  performance_insights_enabled   = var.performance_insights_enabled
  performance_insights_kms_key_id = var.performance_insights_kms_key_id
  performance_insights_retention_period = var.performance_insights_retention_period
  skip_final_snapshot            = true
  tags = var.tags
}
