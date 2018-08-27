# There is no guarantee of what region or ami we need, so to make
# it more uniform and robust we use a data resource to query AWS 
# for information that we can later use throughout our tf
data "aws_ami" "ubuntu16" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }
}