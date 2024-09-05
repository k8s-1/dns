#!/bin/bash

# run coredns
docker-compose up -d

# query our server from a client in the same subnet or from the server directly
# docker by default uses bridge networking - a private virtual network @172.*.*.* on the docker host
DNS_SERVER_IP=$(docker inspect coredns | jq -r '.[0].NetworkSettings.Networks.coredns_default.IPAddress')
dig @"$DNS_SERVER_IP" host.example.com
