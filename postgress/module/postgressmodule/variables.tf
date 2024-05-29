variable "db_name" {
  description = "The name of the database"
  type        = string
}

variable "db_instance_class" {
  description = "The instance class for the database"
  type        = string
}


variable "allocated_storage" {
  description = "The allocated storage (in GB)"
  type        = number
}

variable "max_allocated_storage" {
  description = "The upper limit to which RDS can automatically scale the storage"
  type        = number
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate"
  type        = list(string)
  default     = []
}
variable "db_subnet_group_name" {
  description = "The DB subnet group to associate with"
  type        = string
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
}



variable "username" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = string
}

variable "password" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = string
}

variable "storage_type" {
  description = "The storage type to be associated with the RDS instance"
  type        = string
}

variable "backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
}

variable "maintenance_window" {
  description = "The maintenance window for the RDS instance"
  type        = string
}

variable "backup_window" {
  description = "The backup window for the RDS instance"
  type        = string
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  type        = bool
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key"
  type        = string
}

variable "copy_tags_to_snapshot" {
  description = "Copy all tags to snapshots"
  type        = bool
  default     = true
}





variable "performance_insights_enabled" {
  description = "Specifies whether Performance Insights are enabled"
  type        = bool
}

variable "performance_insights_kms_key_id" {
  description = "The ARN for the KMS key used to encrypt Performance Insights data"
  type        = string
}

variable "performance_insights_retention_period" {
  description = "The amount of time in days to retain Performance Insights data"
  type        = number
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}


