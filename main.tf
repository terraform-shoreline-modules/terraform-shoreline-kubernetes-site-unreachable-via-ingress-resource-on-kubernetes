terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "site_unreachable_via_ingress_resource_on_kubernetes" {
  source    = "./modules/site_unreachable_via_ingress_resource_on_kubernetes"

  providers = {
    shoreline = shoreline
  }
}