# bash ./scripts/install.sh transportation
#./rbac-gitlab.sh mobile-next  wi-cicd-runner 
echo "HTTPS_PROXY: $HTTPS_PROXY"

ksa="wi-cicd-runner"
gitlab_namespace="gitlab"
Namespace="$1"
ksa="$2"
kubectl create namespace $gitlab_namespace
cred_gkes=`kubectl config current-context | awk -F'_' '{print $2}'`
cluster_name=`kubectl config current-context | awk -F'_' '{print $NF}'`


gkeenv=`echo $cred_gkes | awk -F'-' '{print $NF}'`


echo $cred_gkes
echo $cluster_name
echo $gkeenv
echo $ksa

# project="idstaff"
# env="prod"
# ##################################################################################
#  annotations:
#    iam.gke.io/gcp-service-account=flux-gcp@total-mayhem-123456.iam.gserviceaccount.com
 
kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: $ksa
  namespace: $gitlab_namespace
---
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: $ksa
  namespace: $gitlab_namespace
rules:
- apiGroups: ["*"] # "" indicates the core API group
  resources: ["*"]
  verbs: ["*"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: $ksa
  namespace: $gitlab_namespace
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: $ksa
subjects:
- kind: ServiceAccount
  name: $ksa
EOF



kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: $Namespace
EOF

kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: role-$ksa
  namespace: $Namespace
rules:
- apiGroups: ["*"] # "" indicates the core API group
  resources: ["*"]
  verbs: ["*"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: rolebinding-$ksa
  namespace: $Namespace
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: role-$ksa
subjects:
- kind: ServiceAccount
  name: $ksa
  namespace: $gitlab_namespace
- apiGroup: rbac.authorization.k8s.io
  kind: Group
  name: gcp.$project.operator@yourDomain.com
EOF
