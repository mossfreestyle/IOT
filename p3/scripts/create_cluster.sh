#!/bin/bash

k3d cluster create --config ../confs/k3d-config.yml
kubectl apply -f ../confs/namespace.yml
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


kubectl wait --for=condition=Ready pods --all -n argocd --timeout=180s
echo "ArgoCD is in Running State"
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d
echo ""
kubectl port-forward svc/argocd-server -n argocd 8080:443 &