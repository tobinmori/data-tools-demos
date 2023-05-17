
variable "dms_s3_service_access_role_arn" {
  description = "Access Role"
  default     = "arn:aws:iam::960713385905:role/dms-access-for-endpoint"
}

variable "dms_mvault_memberships_target_bucket_name" {
  description = "Name of target s3 bucket."
  default     = "pbs-mvault-memberships-cdc"
}

variable "dms_mvault_memberships_target_bucket_folder" {
  description = "Name of target s3 bucket folder. Should be the RDS / product name. E.g. mvault, profile-service"
  default     = "pbs-mvault-memberships"
}

variable "dms_target_mvault_cdc_s3_bucket" {
    description = "Target s3 bucket for DMS."
    type        = string
    default     = "dev-pbs-mvault-cdc"
}

