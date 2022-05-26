#!/bin/bash
#./wi_ns.sh jira_ticket namespaces ksa gsa

jira_ticket=$1
namespace=$2
ksa=$3
gsa=$4
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

 #gcloud iam service-accounts add-iam-policy-binding  --role roles/iam.workloadIdentityUser   --member "serviceAccount:$cred_gkes.svc.id.goog[$namespace/$ksa]"   $gsa@"$cred_gkes".iam.gserviceaccount.com  --project $cred_gkes 
#echo kubectl run -it --image google/cloud-sdk:slim --serviceaccount $ksa --namespace $namespace workload-identity-test --rm
echo "Done"