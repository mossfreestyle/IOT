#!/usr/bin/env bash
set -euo pipefail

apt-get update -y
apt-get install -y curl ca-certificates

if ! command -v k3s >/dev/null 2>&1; then
  curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --write-kubeconfig-mode 644 --node-ip 192.168.56.110 --tls-san 192.168.56.110" sh -
fi

mkdir -p /home/vagrant/.kube
cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
chown vagrant:vagrant /home/vagrant/.kube/config
sed -i 's/127.0.0.1/192.168.56.110/' /home/vagrant/.kube/config

# Deploy the sample apps and ingress automatically.
KUBECONFIG=/etc/rancher/k3s/k3s.yaml
export KUBECONFIG

# Wait for node object to exist before waiting on Ready.
until kubectl get nodes --no-headers 2>/dev/null | grep -q .; do
  sleep 2
done
kubectl wait --for=condition=Ready node --all --timeout=180s

if [ -f /vagrant/confs/apps.yaml ]; then
  kubectl apply -f /vagrant/confs/apps.yaml
  kubectl rollout status deployment/app1 --timeout=120s
  kubectl rollout status deployment/app2 --timeout=120s
  kubectl rollout status deployment/app3 --timeout=120s
fi
