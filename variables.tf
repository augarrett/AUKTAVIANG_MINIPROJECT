variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

variable "private_key_path" {
  description = "Enter the path to the SSH Private Key to run provisioner"
  default     = ""
}

variable "public_key_path" {
  description = "Path to the pub key matching the private key supplied"
  default = "/root/.id_rsa.pub"
}
