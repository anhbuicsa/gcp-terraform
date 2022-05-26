# 1. Create GSA 
# 2. Assign KSA with workloadIdentityUser to GSA
# 3. Assign roles to GSA
# Declaration
# default_nss: k8s namespace name
# ksa: k8s service account
# ksa: google service account
# kns: kubernetes namespace



locals {
  # Aggregate

    wi_ksa_gsa = flatten([
    for wi_micro in var.wi_deployments : [
      for ksa in lookup(wi_micro, "ksa", []) : [
        for ns in lookup(ksa, "nss", []) :
        {
          wi_ksa = format("serviceAccount:%s.svc.id.goog[%s/%s]", var.project_id, ns, lookup(ksa, "name",lookup(wi_micro, "gsa", lookup(wi_micro, "gsa", lookup(wi_micro, "existed_gsa","")))))
          wi_gsa = format("%s@%s.iam.gserviceaccount.com", lookup(wi_micro, "gsa", lookup(wi_micro, "gsa", lookup(wi_micro, "existed_gsa",""))), var.project_id)
        }
      ]
    ]
  ])

  wi_gsa_roles = flatten([
    for wi_micro in var.wi_deployments : [
      for role in lookup(wi_micro, "gcp_roles", var.defaul_gcp_roles) :
      {
        wi_gsa    = format("%s@%s.iam.gserviceaccount.com", lookup(wi_micro, "gsa", lookup(wi_micro, "gsa", lookup(wi_micro, "existed_gsa",""))), var.project_id)
        gcp_roles = role
      }
    ]
  ])

   wi_gsa= flatten([
    for wi_micro in var.wi_deployments : [ 
     
     lookup(wi_micro, "gsa", "") != ""? [format("%s:%s",lookup(wi_micro, "gsa", ""),lookup(wi_micro, "jira", ""))]:[]
       
  ]])

}


resource "google_service_account" "wi_gsa" {
  for_each =toset(local.wi_gsa)
  account_id = replace(each.value, "/:.*/", "")
  display_name = replace(each.value, "/:.*/", "")
  description= replace(each.value, "/.*:/", "")
}

resource "google_service_account_iam_member" "self_gsa_token_creator" {
  for_each             = toset(local.wi_gsa)
  service_account_id   = format("projects/%s/serviceAccounts/%s@%s.iam.gserviceaccount.com",var.project_id,replace(each.value, "/:.*/", ""),var.project_id)
  role                 = "roles/iam.serviceAccountTokenCreator"
  member               = format("serviceAccount:%s@%s.iam.gserviceaccount.com",replace(each.value, "/:.*/", ""), var.project_id)
  depends_on         = [google_service_account.wi_gsa]
}


resource "google_service_account_iam_member" "wi_gsa" {
  for_each           = { for wi in local.wi_ksa_gsa : format("%s:%s", replace(wi.wi_gsa, "/@.+/", ""), replace(wi.wi_ksa, "/.+\\[|\\].*/", "")) => wi }
  service_account_id = format("projects/%s/serviceAccounts/%s", var.project_id, each.value.wi_gsa)
  role               = "roles/iam.workloadIdentityUser"
  member             = each.value.wi_ksa
  depends_on         = [google_service_account.wi_gsa]
}

resource "google_project_iam_member" "wi_gsa" {
  project    = var.project_id
  for_each   = { for wi in local.wi_gsa_roles : format("%s:%s", replace(wi.wi_gsa, "/@.+/", ""), wi.gcp_roles) => wi }
  role       = each.value.gcp_roles
  member     = format("serviceAccount:%s", each.value.wi_gsa)
  depends_on = [google_service_account.wi_gsa]
}

