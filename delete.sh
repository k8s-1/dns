#!/bin/bash

set -eux

if [ -f /etc/resolv.conf.bkp ]; then
  sudo cp /etc/resolv.conf.bkp /etc/resolv.conf
  sudo rm /etc/resolv.conf.bkp
fi

cd coredns && docker-compose down
cd - || exit


