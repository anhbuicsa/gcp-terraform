#!/bin/bash

# bash ./rbac.sh namespace group@yourDomain.com jira-ticket
Namespace=$1
Domain_group=$2
group=`echo $Domain_group | awk -F'@' '{gsub(/\.|_/,"-",$1);print $1}'`
annotations="$3"
echo $Namespace $group $annotations
if [ -n "$Namespace" ];then
if [ -n "$annotations" ];then
kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: $Namespace
  annotations:
    jira-ticket: $annotations
EOF
else
kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: $Namespace
EOF
fi;
kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: role-$group
  namespace: $Namespace
rules:
- apiGroups: ["*"] # "" indicates the core API group
  resources: ["pod"]
  verbs: ["get","list","watch"]
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
else
  echo "bash ./rbac.sh namespace group@yourDomain.com jira-ticket"
fi;
