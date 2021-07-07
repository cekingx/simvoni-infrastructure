variable "project" {}

variable "credentials_file" {}

variable "ssh_username" {}

variable "ssh_pub_key" {}

variable "instance_count" {
  default = 3
}

variable "region" {
  default = "asia-southeast2"
}

variable "zone" {
  default = "asia-southeast2-b"
}