#!/bin/bash
set -xe

function die(){
    echo "$1"
    exit 1
}

function run_playbook() {
    echo "Running playbook"
    ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -vv -i inventory playbook.yml
}

# create public key from private key to be added to AWS
ssh-keygen -y -f /root/.id_rsa > /root/.id_rsa.pub

# initialize terraform
terraform init
# create a terraform plan
terraform plan --var private_key_path=/root/.id_rsa
# apply terraform changes to environment
terraform apply --auto-approve --var private_key_path=/root/.id_rsa

# After our infra is created we apply our playbook
echo "Running ansible playbook"
sleep 5
for i in 1 2; do run_playbook && break || sleep 15; done

echo "Getting ready for test suites"
sh ./run_tests.sh || die

echo "Congrats you are setup and have been verified :-)"
echo "Please visit the url at http://$(terraform output public_ip)"


