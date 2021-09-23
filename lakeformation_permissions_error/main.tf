############################################################
# Terraform Setup, Data, and Locals
############################################################

provider "aws" {
  region  = "us-east-1"
  version = "3.50.0"
}

data "aws_caller_identity" "current" {}

locals {
  s3_key = "library/books/books.csv"

  lakeformation_admins = [
    "<ADD OWN ARN HERE>",
    "<ADD OWN ARN HERE>",
  ]
  principal_to_grant = "<ADD OWN ARN HERE>"
}

############################################################
# S3
############################################################
resource "random_string" "bucket_suffix" {
  length  = 12
  upper   = false
  special = false
}

resource "aws_s3_bucket" "data" {
  bucket        = "mytf-test-bucket-${random_string.bucket_suffix.result}"
  force_destroy = true
}

resource "aws_s3_bucket_object" "upload" {
  bucket = aws_s3_bucket.data.id
  key    = local.s3_key
  source = "../sampledata/${local.s3_key}"
}

############################################################
# Database and Table
############################################################
resource "aws_glue_catalog_database" "database" {
  name = "library"
}



resource "aws_glue_catalog_table" "table" {
  name          = "books"
  database_name = aws_glue_catalog_database.database.name
  table_type    = "EXTERNAL_TABLE"

  storage_descriptor {
    location      = "s3://${aws_s3_bucket.data.id}/${aws_glue_catalog_database.database.name}/books"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    columns {
      name = "title"
      type = "string"
    }

    columns {
      name = "author"
      type = "string"
    }

    columns {
      name = "genre"
      type = "string"
    }

    columns {
      name = "year_published"
      type = "string"
    }

    columns {
      name = "rating"
      type = "string"
    }

    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"
      parameters = {
        "skip.header.line.count" = 1
      }
    }
  }
}

############################################################
# Lake Formation admin and resources
############################################################
resource "aws_lakeformation_data_lake_settings" "admin" {
  admins = local.lakeformation_admins
}

resource "aws_lakeformation_resource" "bucket" {
  depends_on = [aws_lakeformation_data_lake_settings.admin]
  arn        = aws_s3_bucket.data.arn
}