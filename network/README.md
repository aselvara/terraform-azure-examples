# Create Resources
- Create a `.env` file with Azure credentials
```
# .env
export ARM_SUBSCRIPTION_ID="****"
export ARM_TENANT_ID="****"
export ARM_CLIENT_ID="***"
export ARM_CLIENT_SECRET="***"
```
- load the `.env` file
```
source .env
```
- Deploy TF resources
```
cd network
terraform init
terraform plan
terraform apply -auto-approve
```
