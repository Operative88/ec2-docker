variable "aws_region" {
  type    = string
  default = "eu-central-1" # Frankfurt
}

variable "project_name" {
  type    = string
  default = "ec2-docker"
}

variable "instance_type" {
  type    = string
  default = "t3.micro" # free-tier friendly; nginx barely needs anything
}

variable "ssh_public_key_path" {
  description = "Path to your public key, e.g. ~/.ssh/ec2_docker.pub"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "Your IP in CIDR form, e.g. 203.0.113.4/32"
  type        = string
}
