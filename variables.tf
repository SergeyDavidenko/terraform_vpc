variable "aws_region" {
  description = "Region for the VPC"
  default = "us-east-1"
}

variable "my_access_key" {
  description = "access_key"
  default = ""
}

variable "my_secret_key" {
  description = "secret_key"
  default = ""
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet"
  default = "10.0.2.0/24"
}

variable "private_subnet_cidr_b" {
  description = "CIDR for the private subnet"
  default = "10.0.3.0/24"
}