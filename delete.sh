#!/bin/bash

set -eux

if [ -f /etc/resolv.conf.bkp ]; then
  cp /etc/resolv.conf.bkp /etc/resolv.conf
  rm /etc/resolv.conf.bkp
fi

cd coredns && docker-compose down
cd - || exit


