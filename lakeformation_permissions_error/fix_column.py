import boto3

# Choose column to add
column_to_add = "rating"

# Get table properties
glue = boto3.client("glue")
table_properties = glue.get_table(DatabaseName="library", Name="books")["Table"]

# Add specified column
column_names = [column["Name"] for column in table_properties["StorageDescriptor"]["Columns"]]
if column_to_add not in column_names:
    table_properties["StorageDescriptor"]["Columns"].append({"Name": column_to_add, "Type": "string"})
    glue.update_table(DatabaseName="library", TableInput=table_properties)
