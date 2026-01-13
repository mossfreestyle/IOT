#!/bin/bash



k3d cluster create --config ../confs/k3d-config.yml
# docker update --memory 8g k3d-mfernand-cluster-server-0
# kubectl create namespace argocd

# kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

helm repo add gitlab https://charts.gitlab.io/
helm repo update

kubectl create namespace gitlab


helm upgrade --install gitlab gitlab/gitlab \
  --namespace gitlab \
  --set global.hosts.domain=localhost \
  --set global.hosts.externalIP=127.0.0.1 \
  -f ../confs/gitlab-config.yml \
  --set certmanager-issuer.email=iot@email.com

echo "Waiting for gitlab to be ready"

kubectl wait --for=condition=Ready pods --all -n gitlab 
# curl http://localhost/-/readiness

echo "gitlab is running correctly"


mkdir -p ../credentials

kubectl get secret gitlab-gitlab-initial-root-password \
  -n gitlab -o jsonpath="{.data.password}" | base64 --decode > ../credentials/gitlab_root_pass.txt
  
kubectl port-forward svc/gitlab-webservice-default -n gitlab 8080:8080 >/dev/null 2>&1 &

# kubectl apply -f confs/argocd-config.yml

# echo "ArgoCD is in Running State"



# kubectl -n argocd get secret argocd-initial-admin-secret \
#   -o jsonpath="{.data.password}" | base64 -d > ../credentials/argocd_pass.txt
# echo "Password to log as admin in argocd set in credentials/argocd_pass.txt"
# kubectl port-forward svc/argocd-server -n argocd 8080:443 >/dev/null 2>&1 &


# ARGOCD_PASS=$(cat ../credentials/argocd_pass.txt)
# 
# argocd login localhost:8080 --username admin --password $ARGOCD_PASS 
# argocd app create -f ../confs/argocd-config.yml
# argocd app get iot
