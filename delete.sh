#!/bin/bash

set -eux

cd coredns && docker-compose down
cd - || exit
