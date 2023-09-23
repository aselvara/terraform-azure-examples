source .env 

cd bastion_host
terraform apply -destroy -auto-approve

cd ../network
terraform apply -destroy -auto-approve
