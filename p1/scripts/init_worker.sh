#!/bin/bash
sudo apt update -y && apt install curl tree -y

while ! tree /vagrant | grep -q node-token; do
    echo "Waiting for Server building... ⏳"
    sleep 1
done

# mkdir -p ~/.ssh
# sudo cp /vagrant/.vagrant/machines/rwassimS/libvirt/private_key ~/.ssh/id_rsa_master
# chmod 600 ~/.ssh/id_rsa_master
# ssh-keyscan -H 192.168.56.110 >> ~/.ssh/known_hosts

echo "WORKER APT UPDATED 📚"
TOKEN=$(cat /vagrant/node-token)
echo "WORKER TOKEN CREATED 🪙"

curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.110:6443 K3S_TOKEN=$TOKEN INSTALL_K3S_EXEC="agent --node-ip=192.168.56.111 --flannel-iface=eth1" sh -
echo "WORKER READY 🟩"