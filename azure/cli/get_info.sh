#!/bin/bash

# list resources

az resource list -g <resource group name>

# list sql server in a group

az sql server list -g <resource group name>

# list sql db in a server

az sql db list -g <resource group name> -s <servername>

az vm show -n devdockerhost -g sqldevopsGroup

az network public-ip list -g sqldevopsGroup

az resource list --query [].[resourceGroup,name,type] -g sqldevopsGroup 

az network public-ip list --query [].[resourceGroup,name,ipAddress] -g sqldevopsGroup