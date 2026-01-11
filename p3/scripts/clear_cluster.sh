#!/bin/bash

k3d cluster list

read -p "Cluster Name: " name

if [ -z "$name" ]; then
    echo "Nothing to delete"
else
    k3d cluster delete "$name"
fi



read -p "Want to delete the cluster containers? [y/N] " yorn

if [[ "$yorn" == "y" || "$yorn" == "Y" ]]; then
    docker rm -f k3d-mfernand-cluster-serverlb
    docker rm -f k3d-mfernand-cluster-server-0
fi


read -p "Want to delete the cluster images? [y/N] " yorn

if [[ "$yorn" == "y" || "$yorn" == "Y" ]]; then
    docker rmi ghcr.io/k3d-io/k3d-proxy:5.8.3
    docker rmi ghcr.io/k3d-io/k3d-tools:5.8.3
    docker rmi rancher/k3s:v1.31.5-k3s1
fi

read -p "Want to delete the cluster volumes? [y/N] " yorn

if [[ "$yorn" == "y" || "$yorn" == "Y" ]]; then
     docker volume rm -f k3d-mfernand-cluster-images
fi


read -p "Want to delete ArgoCD pass? [y/N] " yorn

if [[ "$yorn" == "y" || "$yorn" == "Y" ]]; then
    rm -rf ../credentials/argocd_pass.txt
fi