terraform {
  required_version = ">= 1.3"
  required_providers {
    # tflint-ignore: terraform_unused_required_providers
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = "> 3.0, < 5.0"
      configuration_aliases = [azurerm.p-dns]
    }
    # tflint-ignore: terraform_unused_required_providers
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "~> 1.2, >= 1.2.22"
    }
  }
}
