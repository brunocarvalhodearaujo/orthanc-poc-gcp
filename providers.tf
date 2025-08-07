terraform {
  required_version = ">= 1.0.10"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.21.0"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.0"
    }
  }

  backend "gcs" {
    bucket = "mable-terraform-remote-states"
    prefix = "mundial/server"
  }
}

provider "google" {}
