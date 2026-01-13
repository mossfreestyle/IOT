#!/bin/bash



k3d cluster create --config ../confs/k3d-config.yml
kubectl create namespace argocd

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl wait --for=condition=Ready pods --all -n argocd --timeout=180s
kubectl apply -f confs/argocd-config.yml

echo "ArgoCD is in Running State"

mkdir -p ../credentials


kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d > ../credentials/argocd_pass.txt
echo "Password to log as admin in argocd set in credentials/argocd_pass.txt"
kubectl port-forward svc/argocd-server -n argocd 8080:443 >/dev/null 2>&1 &


ARGOCD_PASS=$(cat ../credentials/argocd_pass.txt)

argocd login localhost:8080 --username admin --password $ARGOCD_PASS 
argocd app create -f ../confs/argocd-config.yml
argocd app get iot
