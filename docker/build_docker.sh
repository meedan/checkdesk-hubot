#!/bin/bash

IMAGE=dreg.meedan.net/checkdesk/checkbot
VERSION=local

dir=$(pwd)
cd $(dirname "${BASH_SOURCE[0]}")
cd ..

# Build
docker build -t ${IMAGE}:${VERSION} .

