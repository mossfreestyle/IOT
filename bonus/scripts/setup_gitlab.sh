#!/bin/bash
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
sudo cp /etc/gitlab/initial_root_password ../credentials/gitlab_root_mdp.txt
sudo chmod +r ../credentials/gitlab_root_mdp.txt
#pour se log user: root, mdp: ../credentials/gitlab_root_mdp.txt