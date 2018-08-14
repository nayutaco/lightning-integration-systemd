#!/bin/bash
cd /opt
test -d lightning-integration \
  || git clone https://github.com/cdecker/lightning-integration.git lightning-integration \
  || exit 1

set -e
cd lightning-integration

git pull

docker build --no-cache -t lightning-integration .
docker run \
  -v reports:/root/lightning-integration/reports \
  -v output:/root/lightning-integration/output \
  lightning-integration make update clients test site

az storage blob upload-batch --account-name lightningintegration -d '$web/reports' -s reports
az storage blob upload-batch --account-name lightningintegration -d '$web/output' -s output
