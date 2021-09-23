variable "permission_state" {
  default = 1
  type = number
}

############################################################
# Lake Formation Permission creates a different permission based on var.permission_state
############################################################


resource "aws_lakeformation_permissions" "lf_permission" {
  depends_on  = [aws_lakeformation_data_lake_settings.admin, aws_lakeformation_resource.bucket, aws_glue_catalog_table.table]
  permissions = ["SELECT"]
  principal   = local.principal_to_grant

  dynamic "table_with_columns" {
    for_each = var.permission_state == 1 ? ["create"] : []
    content {
      database_name = aws_glue_catalog_database.database.name
      name          = aws_glue_catalog_table.table.name
      column_names  = ["author", "rating"]
    }
  }

  dynamic "table_with_columns" {
    for_each = var.permission_state == 2 ? ["create"] : []
    content {
      database_name = aws_glue_catalog_database.database.name
      name          = aws_glue_catalog_table.table.name
      column_names  = ["author"]
    }
  }
}

