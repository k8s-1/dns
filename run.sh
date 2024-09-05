#!/bin/bash

set -eux

# always start clean
./delete.sh

minikube start
minikube addons enable ingress

sleep 20

# kind create cluster --config - <<EOF
# kind: Cluster
# apiVersion: kind.x-k8s.io/v1alpha4
# nodes:
#   - role: control-plane
#   - role: worker
# EOF
# kubectl cluster-info --context kind-kind

kustomize build ./cluster/ | { kubectl apply -f - || kubectl apply -f - ;}

sleep 5

cd coredns
# configure corefile to use variable nodeport
NODE_PORT=$(kubectl get svc pihole-nodeport -o jsonpath='{.spec.ports[0].nodePort}')
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
sed \
  -e "s/NODE_PORT/$NODE_PORT/g" \
  -e "s/NODE_IP/$NODE_IP/g" \
  ./Corefile.template > ./Corefile
# run coredns
docker-compose up -d
cd ..

sleep 5

# query our server from a client in the same subnet or from the server directly
# docker by default uses bridge networking - a private virtual network @172.*.*.* on the docker host
DNS_SERVER_IP=$(docker inspect coredns | jq -r '.[0].NetworkSettings.Networks.coredns_default.IPAddress')
dig @"$DNS_SERVER_IP" host.test.homelab


# temporarily override local DNS /etc/resolve.conf
if [ -f /etc/resolv.conf.bkp ]; then
  echo "/etc/resolv.conf.bkp already exists!"
  exit 1
else
  sudo cp /etc/resolv.conf /etc/resolv.conf.bkp
  echo "nameserver $DNS_SERVER_IP" | sudo tee /etc/resolv.conf
fi


dig +short @"$DNS_SERVER_IP"  nginx.external-dns-test.homelab.com
