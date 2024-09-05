#!/bin/bash

set -eux

cp /etc/resolv.conf.bkp /etc/resolv.conf

cd coredns && docker-compose down
cd - || exit


