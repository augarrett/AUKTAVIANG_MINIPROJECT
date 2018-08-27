variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

variable "shared_credentials_file" {
  description = "AWS credentials file. Should contain AWS_SECRET_KEY and AWS_ACCESS_KEY"
  default     = ""
} 
variable "aws_profile" {
  description = "AWS profile to use. If no profile is supplied a default of `default` "
  default = "default"
}

variable "private_key_path" {
  description = "Enter the path to the SSH Private Key to run provisioner"
  default     = ""
}

variable "public_key_path" {
  description = "Path to the pub key matching the private key supplied"
  default = "/root/.id_rsa.pub"
}

# variable "aws_key_pair_name" {
#   description = "aws key name that matches private key"
#   default     = "automation-key"
# }

# variable "subnet_id" {
#   description = "Id of the subnet in the default VPC for the region"
#   default     = "subnet-65256248"
# }

# variable "security_group_id" {
#   description = "List of security groups to apply to instance"
#   default     = ["sg-15ae0e69"]
#   type        = "list"
# }
