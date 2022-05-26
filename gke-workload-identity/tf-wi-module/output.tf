output "service_account_email" {
  description = "List of service account email"
  value       = values(google_service_account.wi_gsa)[*].email  
}

output "service_account_id" {
  description = "List of service account id"
  value       = values(google_service_account.wi_gsa)[*].id  
}