#!/bin/bash

k3d cluster list

read -p "Cluster Name: " name

if [ -z "$name" ]; then
    echo "Nothing to delete"
else
    k3d cluster delete "$name"
    rm -rf ../credentials/argocd_pass.txt
fi



read -p "Want to clear docker images? [y/N] " yorn

if [[ "$yorn" == "y" || "$yorn" == "Y" ]]; then
    docker rm -f k3d-mfernand-cluster-serverlb
    docker rm -f k3d-mfernand-cluster-server-0
    docker rmi ghcr.io/k3d-io/k3d-proxy:5.8.3
    docker rmi ghcr.io/k3d-io/k3d-tools:5.8.3
    docker rmi rancher/k3s:v1.31.5-k3s1
fi

read -p "Want to clear Jenkins? [y/N] " YORN

if [[ "$YORN" == "y" || "$YORN" == "Y" ]]; then
    docker rm -f jenkins
    docker rmi jenkins/jenkins:lts
    rm -rf ../credentials/jenkins_pass.txt
fi