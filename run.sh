#!/bin/bash
set -e

function die(){
    echo "$1"
    exit 1
}

# Get private key location
PRIV_KEY_LOC=$1

# Check if credentials file exists
if [ ! -f ~/.aws/credentials ]; then
    echo "AWS credentials file does not exist. Please make sure one is located at ~/.aws/credentials"
fi

# AWS credentials
AWS_FILE=~/.aws/credentials

# check for private key location
if [[ -z $PRIV_KEY_LOC ]] ; then
    echo "Could not find private key path. Please supply so that we can begin"
    die
fi

# Create build image to run scripts
echo "Building docker image for run"
docker build -t stelligent -f Dockerfile . || die

# Create docker container sharing terraform state files between container and host
docker run -d -it -v $PRIV_KEY_LOC:/root/.id_rsa -v $AWS_FILE:/root/.aws/credentials \
    -v $PWD/terraform.tfstate:/app/terraform.tfstate \
    -v $PWD/terraform.tfstate:/app/terraform.tfstate.backup \
    --name stelligent stelligent || docker rm -f stelligent && echo "Please run script again. Ran into an issue with a docker container not cleaning up properly"
    
# run application script inside container
chmod +x app_install.sh
docker exec -it stelligent sh app_install.sh