# Error with aws_lakeformation_permissions

## Summary

The resource `aws_lakeformation_permissions` encounters an error when trying to remove a permission for a column
that no longer exists. To reproduce the issue, code is supplied for terraform to create a glue table and lake formation 
permission. There is also a python script that can remove a column from a glue table. There is a `run.sh` script which
runs this terraform with a Lake Formation permission for a column named `rating`, then runs a python script to delete
`rating` from the glue table, and then runs terraform again to remove the Lake Formation permission for `rating`.


## Steps to reproduce
Pre-requisities to running tests:
- You should have python installed.
- Create and source your python virtual environment.
- Modify the locals block in `main.tf` to include your own `lakeformation_admins` and `principal_to_grant`


Within this directory run the following commands:
- `pip install -r -requirements.txt`
- `sh run.sh`


## Error
Sample output below is provided with some masked values
```
Error: unable to revoke LakeFormation Permissions (input: {
  Permissions: ["SELECT"],
  PermissionsWithGrantOption: [],
  Principal: {
    DataLakePrincipalIdentifier: "arn:aws:iam::111111111111:role/my-role-name"
  },
  Resource: {
    TableWithColumns: {
      CatalogId: "111111111111",
      ColumnNames: ["author","rating"],
      DatabaseName: "library",
      Name: "books"
    }
  }
}): unable to revoke Lake Formation Permissions: InvalidInputException: Unsupported modification: cannot grant/revoke permission on non-existent column.


```
