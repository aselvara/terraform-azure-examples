source .env

cd network
terraform init
terraform apply -auto-approve

cd ../bastion_host
terraform init
terraform apply -auto-approve
