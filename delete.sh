#!/bin/bash

set -eux

if [ -f /etc/resolv.conf.bkp ]; then
  sudo cp /etc/resolv.conf.bkp /etc/resolv.conf
  sudo rm /etc/resolv.conf.bkp
else
  : no /etc/resolv.conf.bkp found
fi

cd coredns && docker-compose down
cd - || exit

minikube stop || true
minikube delete || true
# kind delete cluster
