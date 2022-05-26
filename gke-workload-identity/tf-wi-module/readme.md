### Step 1 Upload the tf-wi-module folder to your remote reposistory
### Step 2 Run terrafrom to create gsa and map ksa and gsa
```

module "wi_istio_cicd_runner" {
  source         = "git::ssh://git@source-control-domain/tf-wi-module.git"
  project_id     = var.project_id
  wi_deployments = [
    {
      #existed_gsa = "istio-cicd-runner"
      gsa  = "wi-istio-cicd-runner" #   Create GCP Service Account (GSA).
      jira = "cloud-5811"
      ksa  = [
        {
          name = "istio-cicd-runner"
          nss = [
            "istio-prod-gitlab"
          ]
        },
      ]
      gcp_roles = [ # Grant appropriate IAM roles/permissions to the GSA.
        "roles/container.developer",
        "roles/storage.objectCreator",
      ]
    },
  ]
}

Step 2 create namspace, create ksa, annotate ksa, gsa
# Create K8s service account (KSA)
# Bind the KSA and GSA
go to: ./src and run
bash ./wi_ns.sh cloud-5811 istio-prod-gitlab istio-cicd-runner wi-istio-cicd-runner

```
