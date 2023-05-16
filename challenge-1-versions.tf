terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.44.1"
    }
    random = {
        source = "hashicorp/random"
        version = ">=3.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features { }
}

resource "random_string" "myrandom" {
  length = 6
  upper = false
  special = false
  numeric = false
}