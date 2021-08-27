# Error with aws_glue_catalog_table

## Summary

Creating a resource link using `target_table` in `aws_glue_catalog_table` initially works after running
`terraform apply`. However, keeping all configuration the same, a subsequent `terraform plan` shows that it is trying 
to update the resource. It changes many values to null which makes the table unqueryable to Athena. Please
see the `Error` section below for the plan output.

## Steps to reproduce

Within this directory run the following commands:
- `terraform init`
- `terraform apply`
- `terraform plan`

## Error
The output below is returned upon a `terraform plan` after a `terraform apply`. (Account IDs are replaced with fake account ID 111111111111)
```
  # aws_glue_catalog_table.table_link will be updated in-place
  ~ resource "aws_glue_catalog_table" "table_link" {
        arn           = "arn:aws:glue:us-east-1:111111111111:table/library_link/books_link"
        catalog_id    = "111111111111"
        database_name = "library_link"
        id            = "111111111111:library_link:books_link"
        name          = "books_link"
        parameters    = {}
        retention     = 0
      - table_type    = "EXTERNAL_TABLE" -> null

      - storage_descriptor {
          - bucket_columns            = [] -> null
          - compressed                = false -> null
          - input_format              = "org.apache.hadoop.mapred.TextInputFormat" -> null
          - location                  = "s3://mytf-test-bucket-1fiwwivnbcd8/library/books" -> null
          - number_of_buckets         = 0 -> null
          - output_format             = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat" -> null
          - parameters                = {} -> null
          - stored_as_sub_directories = false -> null

          - columns {
              - name       = "title" -> null
              - parameters = {} -> null
              - type       = "string" -> null
            }
          - columns {
              - name       = "author" -> null
              - parameters = {} -> null
              - type       = "string" -> null
            }
          - columns {
              - name       = "genre" -> null
              - parameters = {} -> null
              - type       = "string" -> null
            }
          - columns {
              - name       = "year_published" -> null
              - parameters = {} -> null
              - type       = "string" -> null
            }
          - columns {
              - name       = "rating" -> null
              - parameters = {} -> null
              - type       = "string" -> null
            }

          - ser_de_info {
              - parameters            = {
                  - "skip.header.line.count" = "1"
                } -> null
              - serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde" -> null
            }
        }

        target_table {
            catalog_id    = "111111111111"
            database_name = "library"
            name          = "books"
        }
    }
```