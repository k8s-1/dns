#!/bin/bash

set -eux

workdir="$(pwd)"

./"$workdir"/cluster/create-cluster.sh

./"$workdir"/coredns/create-dns.sh

