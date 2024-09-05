#!/bin/bash

set -e

cd coredns && docker-compose down
cd - || exit
