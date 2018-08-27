#!/bin/bash
set -xe

# Use terraform to get priv_key_loc and public ip
PRIV_KEY_LOC=$(terraform output priv_key_loc)
HOST_IP=$(terraform output public_ip)
# Make copy of terraform output
terraform output --json > test/verify/files/terraform.json

echo "verify test for sanity"
inspec check test/verify

echo "running infra/unit test"
inspec exec test/verify/ --controls aws -t aws://
echo "infra/unit test are successful"

echo "running app/integration test"
inspec exec test/verify/ --controls integration -t ssh://ubuntu@$HOST_IP -i $PRIV_KEY_LOC
echo "app/integration test suite are successul"
