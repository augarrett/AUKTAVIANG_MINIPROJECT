terraform {
  required_version = ">= 0.11.4"
}

provider "aws" {
  region                  = "${var.aws_region}"
}

#
# Network. We create a VPC, gateway, subnets and security groups.
#
resource "aws_vpc" "vpc_main" {
  cidr_block = "10.0.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name = "Main VPC"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.vpc_main.id}"
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.vpc_main.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

# Create a public subnet to launch our load balancers
resource "aws_subnet" "public" {
  vpc_id                  = "${aws_vpc.vpc_main.id}"
  cidr_block              = "10.0.1.0/24"          
  map_public_ip_on_launch = true
}


# Our default security group to access the instances over SSH and HTTP
resource "aws_security_group" "default" {
  name        = "sec_group_private"
  description = "Security Group for stelligent"
  vpc_id      = "${aws_vpc.vpc_main.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# The key pair which will be installed on the instances later.
resource "aws_key_pair" "auth" {
  key_name   = "automate-me"
  public_key = "${file(var.public_key_path)}"
}

module "ubuntu16" {
  source            = "./instance"
  cloud9_ami        = "${data.aws_ami.ubuntu16.id}"
  key_name          = "${aws_key_pair.auth.id}"
  username          = "ubuntu"
  group_name        = "ubuntu16"
  subnet_id         = "${aws_subnet.public.id}"
  security_group_id = "${aws_security_group.default.id}"
  private_key_path = "${var.private_key_path}"
}