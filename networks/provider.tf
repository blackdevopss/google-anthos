terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.3.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "4.19.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "4.11.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.21.0"
    }

  }
}

provider "azuread" {
  client_id       = var.client_id
  client_secret   = var.client_secret
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  # Configuration options
}

provider "azurerm" {
  client_id       = var.client_id
  client_secret   = var.client_secret
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  features {

  }
  # Configuration options
}


provider "google" {
  project     = var.gcp_project_id
  credentials = file(var.gcp_credentials)
  region      = var.gcp_region
  # Configuration options
}


provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  # Configuration options
}

terraform {
  cloud {
    organization = "blackdevopss"

    workspaces {
      name = "google-anthos"
    }
  }
}