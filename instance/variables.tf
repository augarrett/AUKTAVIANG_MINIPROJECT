variable "private_key_path" {
  description = "Enter the path to the SSH Private Key to run provisioner."
  default     = ""
}

variable "disk_size" {
  default = 8
}

variable "count" {
  default = 1
}

variable "group_name" {
  description = "Group name becomes the base of the hostname of the instance"
}

variable "instance_type" {
  description = "AWS region to launch servers."
  default     = "t2.small"
}

variable "key_name" {
  description = "Name of the keypair to use for SSH"
}

variable "username" {
  description = "Username of ec2 instance"
}

variable "cloud9_ami" {
  description = "AMI used by cloud9 team. Defaults to grabbing the latest in the region"
}

variable "subnet_id" {
  description = "Id of the subnet in the default VPC for the region"
}

variable "security_group_id" {
  description = "List of security groups to apply to instance"
}
