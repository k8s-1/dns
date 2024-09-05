#!/bin/bash

cd ./coredns && docker-compose up -d
cd - || exit
