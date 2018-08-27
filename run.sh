#!/bin/bash
cd /opt
test -d lightning-integration \
  || git clone https://github.com/cdecker/lightning-integration.git lightning-integration \
  || exit 1

cd lightning-integration
git pull || exit 1

mkdir output

docker build --no-cache -t lightning-integration . || exit 1
docker run \
  -v reports:/root/lightning-integration/reports \
  -v output:/root/lightning-integration/output \
  lightning-integration make update clients test site

az storage blob upload-batch --account-name $AZURE_STORAGE_ACCOUNT -d '$web/reports' -s reports
az storage blob upload-batch --account-name $AZURE_STORAGE_ACCOUNT -d '$web/output' -s output
