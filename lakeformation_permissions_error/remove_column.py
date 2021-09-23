import boto3

# Choose column to remove
column_to_remove = "rating"

# Get table properties
glue = boto3.client("glue")
table_properties = glue.get_table(DatabaseName="library", Name="books")["Table"]

# Remove specified column
for i, column in enumerate(table_properties["StorageDescriptor"]["Columns"]):
    if column["Name"] == column_to_remove:
        del table_properties["StorageDescriptor"]["Columns"][i]

# Remove extra fields that update_table does not accept
fields_not_accepted_for_update_table = [
    "DatabaseName", "CreateTime", "UpdateTime", "CreatedBy", "IsRegisteredWithLakeFormation", "CatalogId"
]
[table_properties.pop(k) for k in fields_not_accepted_for_update_table]

# Update the table
glue.update_table(DatabaseName="library", TableInput=table_properties)
print(f"Removed column {column_to_remove} from library.books")
