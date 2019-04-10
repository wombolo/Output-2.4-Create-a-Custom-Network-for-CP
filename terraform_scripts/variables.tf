variable "aws_region" {
  default = "eu-west-3"
}

variable "vpc_cidr" {
  description = "CIDR block for the whole VPC"
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

variable "bastion-ami-id" {
  default = "ami-03bca18cb3dc173c9"
}