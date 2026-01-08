#!/bin/bash



k3d cluster create --config ../confs/k3d-config.yml
# kubectl apply -f ../confs/namespace.yml

# kubectl apply -f ../confs/deployment.yml
# kubectl apply -f ../confs/service.yml
# kubectl apply -f ../confs/ingress.yml
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