#!/bin/bash
#source https://docs.gitlab.com/install/package/debian/?tab=Community+Edition
sudo systemctl enable --now ssh
sudo apt install -y curl ufw

sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable


curl "https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh" | sudo bash


#On peux set aussi la variable d env pour le mail admin et mdp admin
sudo EXTERNAL_URL="http://localhost:5555" \
apt install gitlab-ce

mkdir -p ../credentials/
sudo cp /etc/gitlab/initial_root_password ../credentials/gitlab_root_pass.txt
sudo chmod +r ../credentials/gitlab_root_mdp.txt
#pour se log user: root, mdp: ../credentials/gitlab_root_mdp.txt









curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

helm repo add gitlab https://charts.gitlab.io/
helm repo update

kubectl create namespace gitlab


helm upgrade --install gitlab gitlab/gitlab \
  --namespace gitlab \
  --set global.hosts.domain=localhost \
  --set global.hosts.externalIP=127.0.0.1 \
  --set certmanager-issuer.email=iot@email.com

kubectl get secret gitlab-gitlab-initial-root-password \
  -n gitlab -o jsonpath="{.data.password}" | base64 --decode > ../credentials/gitlab_root_pass.txt
