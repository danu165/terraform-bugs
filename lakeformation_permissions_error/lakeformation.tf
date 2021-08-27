locals {

  lakeformation_admins = [
    "<ADD OWN ARN HERE>",
    "<ADD OWN ARN HERE>",
  ]
  principal_to_grant = "<ADD OWN ARN HERE>"

  permission_test = 1 # Can be 1, 2, or 3
}

resource "aws_lakeformation_data_lake_settings" "admin" {
  admins = local.lakeformation_admins
}

resource "aws_lakeformation_resource" "bucket" {
  depends_on = [aws_lakeformation_data_lake_settings.admin]
  arn        = aws_s3_bucket.data.arn
}

resource "aws_lakeformation_permissions" "lf_permission1" {
  depends_on  = [aws_lakeformation_data_lake_settings.admin, aws_lakeformation_resource.bucket]
  count       = local.permission_test == 1 ? 1 : 0
  permissions = ["SELECT"]
  principal   = local.principal_to_grant

  table {
    database_name = aws_glue_catalog_database.database_link.name
    wildcard      = true
  }
}

resource "aws_lakeformation_permissions" "lf_permission2" {
  depends_on  = [aws_lakeformation_data_lake_settings.admin, aws_lakeformation_resource.bucket]
  count       = local.permission_test == 2 ? 1 : 0
  permissions = ["SELECT"]
  principal   = local.principal_to_grant

  table {
    database_name = aws_glue_catalog_database.database_link.name
    name          = aws_glue_catalog_table.table_link.name
  }
}

resource "aws_lakeformation_permissions" "lf_permission3" {
  depends_on  = [aws_lakeformation_data_lake_settings.admin, aws_lakeformation_resource.bucket]
  count       = local.permission_test == 3 ? 1 : 0
  permissions = ["SELECT"]
  principal   = local.principal_to_grant

  table_with_columns {
    database_name = aws_glue_catalog_database.database_link.name
    name          = aws_glue_catalog_table.table_link.name
    column_names  = ["year_published"]
  }
}

