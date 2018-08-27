#!/bin/bash
set -xe

echo "Destroy build"
docker exec -it stelligent sh -c "terraform destroy --auto-approve --var private_key_path=/root/.id_rsa" ||
 echo "No infra to cleanup"
echo "Removing build"
docker rm -f stelligent || true
docker rmi stelligent || true
rm inventory || true