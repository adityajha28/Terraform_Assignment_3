variable "env" {
  description = "Environment name"
  type        = string
}

variable "ami_id" {
  description = "AMI id for the instance"
  type = string
  default = "ami-06b72b3b2a773be2b"  
}

variable "instance_type" {
  description = "instance type"
  type        = string
  default = "t2.micro"
}

variable "subnet_id" {
  description = "subnet id"
  type        = string
}

variable "vpc_id" {
  description = "vpc id"
  type        = string
}




