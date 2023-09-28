Bastion Host is very helpful if you want to interact with Azure resources in Private network.  Creating a Bastion Host environment is kinda tricky as it requires lot of resources to be created. In this directory you will find every terraform resources needed to create bastion env.

# Create Resources
- First create TF resources in network folder
```
cd network
terraform init
terraform apply -auto-approve
```
- Create Bastion Host resources
```
cd bastion_host
terraform init
terraform apply -auto-approve
```

# Destroy Resources
- First delete the bastion host
```
cd bastion_host
terraform apply -destroy -auto-approve
```
- Delete the network resources
```
cd network
terraform apply -destroy -auto-approve
```

### To access ACR
```bash
 az login --identity
 az acr login --name <acr_name>
 docker image pull <>
 docker image push <>
```

### To find image for Terraform VM
```powershell
$location = "East US"
Get-AzVMImagePublisher -Location $location | Select PublisherName

$publisher = "Canonical"
Get-AzVMImageOffer -Location $location -PublisherName $publisher | Select Offer

$offer = "0001-com-ubuntu-minimal-jammy" # "UbuntuServer" 
Get-AzVMImageSku -Location $location -PublisherName $publisher -Offer $offer | Select Skus
```