provider "google" {
  project = var.project_id
  alias   = "tokengen"
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email",
    "https://www.googleapis.com/auth/devstorage.full_control"
  ]
}

#tf refresh -target data.google_service_account_access_token.sa
data "google_service_account_access_token" "sa" {
  provider               = google.tokengen
  target_service_account = "<gcp_manage_state_service_account>"
  lifetime               = "3500s"
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/devstorage.full_control"
  ]
}

provider "google" {
  access_token = data.google_service_account_access_token.sa.access_token
  project      = var.project_id
}
#
provider "google-beta" {
  access_token = data.google_service_account_access_token.sa.access_token
  project      = var.project_id
}

