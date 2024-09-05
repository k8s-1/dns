#!/bin/bash

set -eux

cd coredns && ./create-dns.sh && cd -

cd cluster && ./create-cluster.sh && cd -
