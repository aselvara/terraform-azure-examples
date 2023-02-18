# terraform-azure-examples

# Helpers
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
