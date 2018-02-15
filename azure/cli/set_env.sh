#!/bin/bash

az login

# get all subscriptions
az account list 
az account list --query [].[name]

# set the active subsrcription
as account set -s "account name or id"