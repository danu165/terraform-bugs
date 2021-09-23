terraform init
terraform apply -auto-approve -var="permission_state=1"
python remove_column.py
terraform apply -auto-approve -var="permission_state=2"