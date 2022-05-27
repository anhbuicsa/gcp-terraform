# gcp-tf-temp

Traditionally terraform used json key as the below. Applications and users can authenticate as a service account using generated service account keys. 
```hcl
provider "google" {
 credentials = file("google-service-account.json")
 project = "playground-project-id"
 region = "asia-east1”
}
```
It is recommended to use Google Cloud Service Account impersonation in your Terraform code. The folder contains the guide and the template which is used widely in my company as the following:

# Change Terraform configuration
### 1. Create GCS bucket and Enable versioning for the bucket
### 2. Copy this folder and change backend.tf file
The backend.tf file defines the configurations of state file and define the way to access and modify the state file
   - [ ] Change **terraform_state_bucket** to the above bucket name
   - [ ] Change **gcp_manage_state_service_account** to the appropriate google service account which can read, write or delete the state object in GCS. Ensure that you or terraform runner has the token creator permission on gcp_manage_state_service_account. 
```hcl
terraform {
    backend "gcs" {
    bucket      = "<terraform_state_bucket>"
    impersonate_service_account = "<gcp_manage_state_service_account>" # Change to your service account name
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

```
### 3. change providers.tf file
The providers.tf file declare which the google service account is used to provision gcp infrastructure. We can use service account key or service account token.
   - [ ] Change **gcp_manage_state_service_account** to the appropriate google service account which is assigned roles provision resource. Ensure that you or terraform runner has the token creator permission on gcp_manage_state_service_account.
```hcl
data "google_service_account_access_token" "sa" {
  provider               = google.tokengen
  target_service_account = "<gcp_manage_state_service_account>" 
# With this method, you also get the token from another step
  lifetime               = "3500s"
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/devstorage.full_control"
  ]
}
```
# Example GCP resouces
   - [ ] Create a new VPC
   - [ ] Create a new NAT router so the nodes or VMs can reach the public Internet
   - [ ] Add subnetworks to the Cloud NAT
   - [ ] Create subnet
# How to run terraform
```bash
terraform init
The terraform init command is used to initialize a working directory containing Terraform configuration files and downloading the GCP provider

terraform plan 
The terraform plan command creates an execution plan, which lets you preview the changes that Terraform plans to make to your infrastructure. 

terraform apply 
The terraform apply command executes the actions proposed in a Terraform plan.
```
