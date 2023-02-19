# terraform-azure-examples
This repository contains examples for creating resources in azure cloud using terraform.  Most of the examples we find in internet deploys in public network and that works for learning but not for enterprise or business. So this repository focuses on creating resources in private network.

# Examples
- **Bastion Host**:  Since we deploy resources in private network, we cannot communicate with them from our workstation through internet.  To communicate with resources in private network, we use [Bastion Host](./bastion_host/).  This spins up a VM in private network and you can connect to the VM using Bastion public IP in Browser.  
- **Container Registry**: Create [private ACR](./acr_private/) (Azure Container Registry).

## Helpers
### Command to install az-cli in Linux
```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
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
