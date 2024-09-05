#!/bin/bash

# configure corefile to use variable nodeport
NODE_PORT=$(kubectl get svc pihole -o jsonpath='{.spec.ports[0].nodePort}')
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
sed \
  -e "s/NODE_PORT/$NODE_PORT/g" \
  -e "s/NODE_IP/$NODE_IP/g" \
  ./Corefile.template > ./Corefile

# run coredns
docker-compose up -d

# query our server from a client in the same subnet or from the server directly
# docker by default uses bridge networking - a private virtual network @172.*.*.* on the docker host
DNS_SERVER_IP=$(docker inspect coredns | jq -r '.[0].NetworkSettings.Networks.coredns_default.IPAddress')
dig @"$DNS_SERVER_IP" host.example.com
