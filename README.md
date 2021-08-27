# Terraform errors with aws_glue_catalog_table and aws_lakeformation_permissions

There seem to several bugs revolving around resource linking with `aws_glue_catalog_table`. The directory
[glue_catalog_table_error](https://github.com/danu165/terraform-bugs/tree/master/glue_catalog_table_error)
goes through the specific bug found with that resource.

As described in [glue_catalog_table_error/README.md](https://github.com/danu165/terraform-bugs/blob/master/glue_catalog_table_error/README.md),
`aws_glue_catalog_table` only works on the first run of a `terraform apply`.
Therefore we went a step further with Lake Formation and noticed additional errors between the integration of
resource-linked `aws_glue_catalog_table` and `aws_lakeformation_permission`. Please refer to
[lakeformation_permissions_error/README.md](https://github.com/danu165/terraform-bugs/blob/master/lakeformation_permissions_error/README.md)
for details.

The provider used is 3.50.0. According to the [changelog](https://github.com/hashicorp/terraform-provider-aws/blob/main/CHANGELOG.md)
there hasn't been work on `aws_glue_catalog_database`, `aws_glue_catalog_table` since 3.47.0. There also hasn't been
any work on `aws_lakeformation_permissions` since 3.49.0. Therefore provider version 3.50.0 should behave the same as
any other recent version.