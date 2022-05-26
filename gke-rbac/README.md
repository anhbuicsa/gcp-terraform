# GKE RBAC

This page shows you how to set up Google Groups to work with Kubernetes role-based access control (RBAC) in your Google Kubernetes Engine (GKE) clusters. Using Google Groups for RBAC also lets you integrate with your existing user account management practices, such as revoking access when someone leaves your organization. We also grant access roles as the group or department as the below image:
![Alt text](https://github.com/anhbuicsa/gcp-terraform/blob/master/gke-rbac/images/RBAC.png?raw=true "Title")

#### Administrators group has Owner in all the namespaces
#### Developers group has pod reader role in all the namespaces
#### Auditor group has reader role in all the namespaces
# Enable RBAC in GKE
![Alt text](https://github.com/anhbuicsa/gcp-terraform/blob/master/gke-rbac/images/GKE-RBAC.png?raw=true "Title")

