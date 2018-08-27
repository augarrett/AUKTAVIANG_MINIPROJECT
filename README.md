# Stelligent Mini-Project

### Problem
Design, code, and test provisioning an environment in AWS.  The code needs to provision the environment resources and configure a web server.  The home page should display a static HTML page with the words: "Automation for the People"

### Assumptions:
- I assumed that this is a fresh AWS account running in us-east-1 region with no configuration/setup outside of IAM user existing with a provisioned API credentials and full permissions to EC2.
**Note: Normally you want to operate with a least privilege model and only give access to the necessary AWS services. For instance granting full EC2 access gives the user access to ECS which is not needed.**
- With those api credentials, store them in your path at **~/.aws/credentials**
- Private key for access to EC2 instance during provisioning and testing
- Linux/MacOS environment with docker in $PATH
- User is not required to supply sudo


### Design/Overview
---
Use [terraform](https://www.terraform.io/) (an infrastructure as code tool) to create necessary AWS resources.
1) Create VPC named "Main VPC"
2) Create internet gateway for VPC
3) Create routing table for VPC
4) Create subnet for VPC
5) Create security groups to allow access
6) Create a key pair from private key passed in
7) Reach out to AWS to query for latest Ubuntu-16.04 AMI in the default region
8) Create EC2 instance
9) Create inventory file needed for Ansible

Use Ansible role **stelligent** to provision EC2 instance(s) created via terraform
1) Use pre task to make sure python exists. Its needed for Ansible
2) Copy Code to remote host (index.html, dockerfile, nginx.conf)
3) Add docker gpg key, and install docker on host
4) Enable Stelligent service and guarantee it will always restart

Use Inspec to test AWS resources, provisioned EC2 instances(s), and control container
1) After infra has been built, run the Inspec profile to audit the correctness of our deployment
2) After the deployment has been created and verified, use the integration profile to check the host(s) if they have been provisioned correctly



### Pre-requisites:
- git
- curl
- docker >= 17.12
    - [MacOSx Docker Install](https://docs.docker.com/docker-for-mac/install/)
    - [Ubuntu Docker Install](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
    You can use the command here to install docker via a shell script
    ```
    curl -L https://get.docker.com/ | sh
    usermod -aG docker $(whoami)
    ```
    - [CentOS-7 Docker Install](https://docs.docker.com/install/linux/docker-ce/centos/)
- Private key to connect to EC2 instance 
    -  We are building things in docker containers, adding private keys to docker images is frowned upon. Instead we add the private key at runtime of the container and it is destroyed when the container is removed.
    - You will need a private key to continue. If you dont have a private key available you can create one using the following.
    ```
    ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
    ```
- AWS Credentials stored in ~/.aws/credentials

### Getting Started:
To get started clone the repo
```
git clone https://github.com/augarrett/AUKTAVIANG_MINIPROJECT
```
Change to cloned directory and run the following to setup environment, run ansible playbook, run inspec test

```
chmod +x run.sh && ./run.sh <<location_of_private_key>>
```
Example
**Note: This will not cleanup your environonment after executing. If we cleaned up immediately after creating our environment we would never have time to go and check out the service on the web.  If you do want to do everything in one command**
```
chmod +x run.sh cleanup.sh &&  ./run.sh <<location_of_private_key>> && ./cleanup.sh
```

### Testing
---
To test the deployment I decided to use (inspec)[https://www.inspec.io/] because of its flexibility.  Using inspec I was able to test AWS resources, the ec2 instance that was created via ssh, and the docker container being used as the control node in the setup.

Here is a list of some of the test that were ran and which they apply to.  This is not an exhaustive list as well as full coverage.  I did not take into account negative testing, stress testing, black box testing but can be added as the test suite grows

1) Make sure VPC, subnet, route table, aws_key exist
2) Make sure ec2 instance is up and running, with correct instance type
3) Logging into EC2 to make sure docker is installed, the service stelligent was created properly

### Cleanup
---
To cleanup environment execute the command below.  This will log into docker container if it still exists, destroy infra created, remove docker container, then remove docker image that was created
```
chmod +x cleanup.sh && ./cleanup.sh
```

**Note: Please make sure to cleanup.  Resources are created in AWS and you will be charged for what you leave around**


### Things to consider
---

These are a few items I thought about along then way.  They are not scoped for this work but would be nice to add so that we can have that next level of assurance 

1) Creating bastion host that doesn't expose host directly to the open world.  Can also add on 2 factor auth for AWS as well as EC2 instances
2) operating system/docker hardening CIS/STIG guidelines
3) Segementing the VPC to smaller networks across different AZ's. This will allow for adding autoscaling group to enhance and map out reliability and help with disaster recovery
4) Add loadbalancer to properly distribute traffic to nodes
5) Add ssl for secure transport with server. (Can use letsencrypt with a DNS server)
6) Using a front end framework to allow enabling testing of client code.  (Can use react for front end development and Jest for testing since Jest is bundled with React)
7) Stress/negative testing
8) Add logging to help diagnose problems
9) Enable monitoring.  Can use cloud trail and cloudwatch 
10) Using a Key Management System.
11) Add consumable API.  This will allow us to better serve customers as well as test api for data instead of a simple curl command
12) Adding retry logic for areas that I have seen crop up with networking issues
13) Use packer to create AMI's that can be quickly used vs installing everything on a vanilla host
14) Manage terraform state in the cloud instead of locally
15) Add to CI/CD pipeline
16) And once again more test :-)



