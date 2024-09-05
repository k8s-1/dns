#!/bin/bash

set -eux

cd cluster && ./create-cluster.sh && cd -

cd coredns && ./create-dns.sh && cd -

