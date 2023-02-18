Bastion Host is very helpful if you want to interact with Azure resources in Private network.  Creating a Bastion Host environment is kinda tricky as it requires lot of resources to be created. In this directory you will find every terraform resources needed to create bastion env.


### To access ACR
```bash
 az login --identity
 az acr login --name <acr_name>
 docker image pull <>
 docker image push <>
```