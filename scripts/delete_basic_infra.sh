set -e 

source .env 

cwd=$(pwd)

cd acr_private
terraform apply -destroy -auto-approve

cd $cwd/app_service
terraform apply -destroy -auto-approve

cd $cwd/bastion_host
terraform apply -destroy -auto-approve

cd $cwd/network
terraform apply -destroy -auto-approve

cd $cwd
