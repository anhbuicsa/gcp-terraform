# GKE RBAC

This page shows you how to set up Google Groups to work with Kubernetes role-based access control (RBAC) in your Google Kubernetes Engine (GKE) clusters. Using Google Groups for RBAC also lets you integrate with your existing user account management practices, such as revoking access when someone leaves your organization. We also grant access roles as the group or department as the below image:
![Alt text](https://github.com/anhbuicsa/gcp-terraform/blob/master/gke-rbac/images/RBAC.png?raw=true "Title")

You can see:
  - Administrators group has Owner in all the namespaces
  - Developers group has pod reader role in all the namespaces
  - Auditors group has reader role in all the namespaces

# 1. Setup and configuration
### Set up your Groups
  - Create a group in your domain named gke-security-groups@YourDomain
  - Add Administrators, Developers and Auditors groups as members of gke-security-groups@YourDomain
### Enable RBAC in GKE
  - Go to the Google Kubernetes Engine page in Cloud console.
  - Click the name of the cluster that you want to update.
  - On the Details tab, locate the Security section.
  - For the Google Groups for RBAC field, click edit Edit Google Groups for RBAC.
  - Select the Enable Google Groups for RBAC checkbox.
  - Fill in Security Group with gke-security-groups@YourDomain.
  - Click Save changes.

![Alt text](https://github.com/anhbuicsa/gcp-terraform/blob/master/gke-rbac/images/GKE-RBAC.png?raw=true "Title")

### Create appropriate roles and rolebindings for each group: Administrators, Developers and Auditors
#### Connect to GKE cluster and check the kubectl run properly then run
```yaml
group="Developers"
Domain_group="Developers@yourdomain.com"
Namespace="dev"
kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: role-$group
  namespace: $Namespace
rules:
- apiGroups: ["*"] # "" indicates the core API group
  resources: ["pod"] # replace pod to * if group is one of Administrators or Auditors group
  verbs: ["get","list","watch"] # replace the value to * if group is Administrators group
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: rolebinding-$group
  namespace: $Namespace
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: role-$group
subjects:
- apiGroup: rbac.authorization.k8s.io
  kind: Group
  name: $Domain_group
EOF
```
### Note:
You also run the script in src directory
# 2. Test access
## Step 1: Create a new user or use an existed user
## Administrators group
- add the user in step 1 as member of Administrators group
- Create a new pod --> OK
- Read a pod --> OK
- Read a secret -->OK
- Remove the user from the group

## Developers group
- add the user in step 1 as member of Developers group
- Create a new pod --> Don't allow
- Read a pod --> OK
- Read a secret --> Don't allow
- Remove the user from the group

## Auditors group
- add the user in step 1 as member of Auditors group
- Create a new pod --> Don't allow
- Read a pod --> OK
- Read a secret --> OK
- Remove the user from the group





