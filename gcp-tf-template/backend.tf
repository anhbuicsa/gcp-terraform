terraform {
    backend "gcs" {
    bucket      = "<terraform_state_bucket>"
    impersonate_service_account = "<gcp_manage_state_service_account>"
    prefix      = "vpc"
  }
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    google-beta = {
      source = "hashicorp/google-beta"
    }
  }
  required_version = ">= 1.2.1"
}
