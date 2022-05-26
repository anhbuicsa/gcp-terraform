# GKE Workload Identity

Workload Identity allows workloads in your GKE clusters to impersonate Identity and Access Management (IAM) service accounts to access Google Cloud services. Workload Identity is enabled by default on Autopilot clusters. Workload Identity is used inside the GCP cloud environment when interact with GCP resource without providing service account key file. Each Workload can use a different the role as well as the Google service account as the below image:
![Alt text](https://github.com/anhbuicsa/gcp-terraform/blob/master/gke-workload-identity/images/workload-identity.png?raw=true "Title")

### Benefit of Workload Identity compares to using service account json key
![Alt text](https://github.com/anhbuicsa/gcp-terraform/blob/master/gke-workload-identity/images/benefit-wi.png?raw=true "Title")
### Require: Enable Workload Identity
You can enable Workload Identity on clusters and node pools using the Google Cloud CLI or the Google Cloud console. Workload Identity must be enabled at the cluster level before you can enable Workload Identity on node pools.
To enable Workload Identity on an existing cluster, do the following:
  - Go to the Google Kubernetes Engine page in Cloud console.
  - In the cluster list, click the name of the cluster you want to modify.
  - On the cluster details page, in the Security section, click edit Edit Workload Identity.
  - In the Edit Workload Identity dialog, select the Enable Workload Identity checkbox.
  - Click Save changes.

![Alt text](https://github.com/anhbuicsa/gcp-terraform/blob/master/gke-workload-identity/images/enable-wi.png?raw=true "Title")

## I. Setup and configuration
### Step 1: Create Google Service Account, assign appropriate roles by using terraform modules which located in tf-wi-module folder
```
#Run terrafrom to create gsa and map ksa and gsa

module "wi_istio_cicd_runner" {
  source         = "git::ssh://git@source-control-domain/cloud-platform/gcp-terraform-modules.git//workload-identities/v0.12-2"
  project_id     = var.project_id
  wi_deployments = [
    {
      #existed_gsa = "bastion-tw"
      gsa  = "wi-istio-cicd-runner" # Create GCP Service Account (GSA).
      jira = "cloud-5811"
      ksa  = [
        {
          name = "istio-cicd-runner"
           #name="wi-deployment"
          nss = [
            "istio-prod-gitlab"
          ]
        },
      ]
      gcp_roles = [
        "roles/container.developer", # Grant appropriate IAM roles/permissions to the GSA.
        "roles/storage.objectCreator",
      ]
    },
  ]
}
```

### Step 2: create ksa, annotate ksa, gsa
#### Create K8s service account (KSA)
#### Annotate the KSA and GSA

```
#!/bin/bash
namespace="namespace_name" # change me
ksa="kube_serviceaccount" # change me
gsa="google_serviceaccount" # change me
cred_gkes=`kubectl config current-context | awk -F'_' '{print $2}'`
echo "create ksa [$ksa]"
kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  annotations:
    iam.gke.io/gcp-service-account: "$gsa@$cred_gkes.iam.gserviceaccount.com"
  name: $ksa
  namespace: $namespace
EOF

```
## II. Testing
### Create a Pod that uses the annotated Kubernetes service account 
```
namespace="namespace_name" # change me
ksa="kube_serviceaccount" # change me
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: workload-identity-test
  namespace: $namespace
spec:
  containers:
  - image: google/cloud-sdk:slim
    name: workload-identity-test
    command: ["sleep","infinity"]
  serviceAccountName: $ksa
  nodeSelector:
    iam.gke.io/gke-metadata-server-enabled: "true"
EOF
```
### Login to pod: 
```
namespace="namespace_name" # change me
kubectl exec -it workload-identity-test \
  --namespace $namespace \
  -- /bin/bash
```
### Run the following command inside the Pod:
```
curl -H "Metadata-Flavor: Google" http://169.254.169.254/computeMetadata/v1/instance/service-accounts/
```
##### Note: Ensure that the output contains the Google IAM service account.