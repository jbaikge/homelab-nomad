terraform {
  required_version = "~> 1.10"

  required_providers {
    nomad = {
      source  = "hashicorp/nomad"
      version = "~> 2.5"
    }
  }
}

provider "nomad" {
  address = "http://cherry.hardwood.cloud:4646"
}
