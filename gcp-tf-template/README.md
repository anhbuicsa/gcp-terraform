# gcp-tf-temp

Traditionally terraform used json key as the below. Applications and users can authenticate as a service account using generated service account keys. 
```
provider "google" {
 credentials = file("google-service-account.json")
 project = "playground-project-id"
 region = "asia-east1”
}
```
It is recommended to use Google Cloud Service Account impersonation in your Terraform code. The folder contains the guide and the template which is used widely in my company as the following:

# Change Terraform configuration
### 1. Create GCS bucket and Enable versioning for the bucket
### 2. change backend.tf file
   - [ ] Change **terraform_state_bucket** to the above bucket name
   - [ ] Change **gcp_manage_state_service_account** to the appropriate google service account which can read, write or delete the state object in GCS. Ensure that you or terraform runner has the token creator permission on gcp_manage_state_service_account.
### 3. change providers.tf file
   - [ ] Change **gcp_manage_state_service_account** to the appropriate google service account which is assigned roles provision resource. Ensure that you or terraform runner has the token creator permission on gcp_manage_state_service_account.
# Example GCP resouces
   - [ ] Create a new VPC
   - [ ] Create a new NAT router so the nodes or VMs can reach the public Internet
   - [ ] Add subnetworks to the Cloud NAT
   - [ ] Create subnet
# How to run terraform
```
terraform init
The terraform init command is used to initialize a working directory containing Terraform configuration files and downloading the GCP provider

terraform plan 
The terraform plan command creates an execution plan, which lets you preview the changes that Terraform plans to make to your infrastructure. 

terraform apply 
The terraform apply command executes the actions proposed in a Terraform plan.
```
