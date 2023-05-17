// Mvault Membership Change Data Capture (CDC)
resource "aws_s3_bucket" "dms-mvault-memberships-target-bucket" {
  bucket = "${var.dms_mvault_memberships_target_bucket_name}-${var.environment}"

  tags = {
    Name        = "${var.environment}-dms-mvault-memberships-cdc"
    Environment = "${var.environment}"
  }
}

# need to add update to policy e.g. tobin-test-dms-s3-policy
#resource "aws_iam_role" "dms-access-for-endpoint" {
#  # (resource arguments)
#}

resource "aws_dms_s3_endpoint" "mvault-cdc-s3-target-endpoint" {
  endpoint_id             = "${var.application_name}-mvault-memberships-s3-target-endpoint"
  endpoint_type           = "target"
  service_access_role_arn = var.dms_s3_service_access_role_arn
  bucket_folder           = var.dms_mvault_memberships_target_bucket_folder
  bucket_name             = "${var.environment}-${var.dms_mvault_memberships_target_bucket_name}"
  
  compression_type        = "GZIP"
  date_partition_enabled  = true
  data_format             = "parquet"
  parquet_version         = "parquet-2-0"

  cdc_path                = "cdc/"
  preserve_transactions   = false # this keeps transactiosn in order!

  tags = merge(
    local.tags,
    {
      Name = "${var.application_name} DMS Mvault Memberships CDC target endpoint"
    }
  )  
}

# Create a new CDC replication task
#data "template_file" "mvault-memberships-table-mappings" {
#  template = file("dms-replication-task-table-mappings.tpl")

#  vars = {
#    schema = "public"
#    table  = "core_memberships"
#  }
#}

resource "aws_dms_replication_task" "mvault-memberships-cdc-replication" {
  migration_type            = "cdc"
  replication_instance_arn  = var.dms_replication_instance_arn
  replication_task_id       = "${var.application_name}-mvault-memberships-cdc-replication"
  source_endpoint_arn       = var.dms_mvault_rds_source_endpoint_arn
  table_mappings            = data.template_file.mvault-memberships-table-mappings.rendered

  tags = merge(
    local.tags,
    {
      Name = "${var.application_name} DMS Mvault Memberships CDC replication"
    }
  )

  target_endpoint_arn = aws_dms_s3_endpoint.mvault-cdc-s3-target-endpoint.endpoint_arn
}
