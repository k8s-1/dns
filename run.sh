#!/bin/bash

docker-compose up -d

# remove login password by setting empty password
docker exec pihole sudo pihole -a -p

DNS_SERVER_IP=$(docker inspect pihole | jq -r '.[0].NetworkSettings.Networks.pihole_default.IPAddress')
dig @"$DNS_SERVER_IP"

echo "pihole url:"
echo "http://localhost:8080/admin/login.php"
