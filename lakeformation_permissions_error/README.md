# Error with aws_lakeformation_permissions

## Summary
The `main.tf` file here is the same as `glue_catalog_table_error/main.tf`. We now add `lakeformation.tf` to bring in
Lake Formation resources. 

In short, `aws_lakeformation_permissions` does not behave properly with resource-linked
tables. There are 3 different types of errors for 3 different types of configurations. 
`aws_lakeformation_permissions` either cannot provision the permissions or provides a false positive. Each
test case is based on the value of `locals.permission_test` located on line 9 of `lakeformation.tf`. To run a
different test, that value should be changed.

Note: due to the error described in the `glue_catalog_table_error` folder, the tests cannot be run with sequential
`terraform apply` commands. You must run `terraform destroy` between each `terraform apply` command.


## Steps to reproduce
All commands below should be run within this directory. 
`locals.permission_test` is located on line 9 of `lakeformation.tf`.

Pre-requisities to running tests:
- Modify the `locals` block to include your own `lakeformation_admins` and `principal_to_grant`
- `principal_to_grant` should be a role/user that you can log in to through the AWS console.
- Run `terraform init`.

Reproducing permission test 1:
- If your `terraform.tfstate` is not empty then run `terraform destroy`.
- Set `locals.permission_test = 1`
- Run `terraform apply`
- Check the Athena console with the role set in `principal_to_grant`. You will not see the table `books_link` under database `library_link`

Reproducing permission test 2:
- If your `terraform.tfstate` is not empty then run `terraform destroy`.
- Set `locals.permission_test = 2`
- Run`terraform apply`

Reproducing permission test 3:
- If your `terraform.tfstate` is not empty then run `terraform destroy`.
- Set `locals.permission_test = 3`
- Run `terraform apply`

## Errors
Permission test 1: This does not produce a terraform error. However, the user cannot see the table in Athena.

Permission test 2 (DataLakePrincipalIdentifier has been masked)
```
Error: error creating Lake Formation Permissions (input: {
  Permissions: ["SELECT"],
  Principal: {
    DataLakePrincipalIdentifier: "arn:aws:iam::************:role/************"
  },
  Resource: {
    Table: {
      DatabaseName: "library_link",
      Name: "books_link"
    }
  }
}): error creating Lake Formation Permissions: InvalidInputException: Permissions modification is invalid.

  on lakeformation.tf line 31, in resource "aws_lakeformation_permissions" "lf_permission2":
  31: resource "aws_lakeformation_permissions" "lf_permission2" {
```

Permission test 3 (DataLakePrincipalIdentifier has been masked)
```
Error: error creating Lake Formation Permissions (input: {
  Permissions: ["SELECT"],
  Principal: { 
    DataLakePrincipalIdentifier: "arn:aws:iam::************:role/************"
  },
  Resource: {
    TableWithColumns: {
      ColumnNames: ["year_published"],
      DatabaseName: "library_link",
      Name: "books_link"
    }
  }
}): error creating Lake Formation Permissions: InvalidInputException: Unsupported modification: cannot grant/revoke permission on non-existent column.

  on lakeformation.tf line 42, in resource "aws_lakeformation_permissions" "lf_permission3":
  42: resource "aws_lakeformation_permissions" "lf_permission3" {

```