terraform {
  required_version = ">= 1.14"
  required_providers {
    azapi = {
      source = "Azure/azapi"
    }
  }
}

provider "azapi" {
}
