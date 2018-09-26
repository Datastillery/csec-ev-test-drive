provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "us-east-1"
  alias = "east1"
}

variable "access_key" {
}
variable "environment" {
  default = ""
}
variable "domain_prefix" {
  default = ""
}
variable "secret_key" {
}
variable "accountName" {
  default = "SmartExperience"
}
variable "account_number" {
  default = "722431446741"
}
variable "region" {
}

variable "vpc_id" {
}

variable "subnet_1" {
}

variable "user" {
  default = "smrt"
}

variable "password" {
}

variable "dns_name" {
}

variable "email_send_from_account" {
  default = "no-reply@drivesmartcbus.com"
}

variable "environment" {

}

variable "send_to_email" {
}

variable "skip_final_snapshot" {
  default = false
}

variable "ami_id" {

}