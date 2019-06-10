variable "aws_region" {
  description = "Region for the VPC"
  default = "eu-central-1"
}

variable "my_access_key" {
  description = "access_key"
}

variable "my_secret_key" {
  description = "secret_key"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default = "10.1.0.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet"
  default = "10.1.1.0/24"
}