# Tencent Cloud variables.
variable "secret_id" {
  default = "Your Access ID"
}

variable "secret_key"{
  default = "Your Access Key"
}

variable "region"{
  description = "The location where instacne will be created"
  default = "ap-seoul"
}

# Default variables
variable "availability_zone" {
  default = "ap-seoul-1"
}

# Name policy

variable "prefix" {
    type = "string"
    default = "my"
}

variable "tags" {
  description = "A map of the tags to use for the resources that are deployed"
  type        = "map"
  
  default = {
    # This value will be the tage text.
    web = "tf-web"
    dev = "tf-dev"
 }

}

# VPC Info
variable "short_name" {
  default = "tf-tmp-vpc"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

# ECS insance variables 
variable "image_id" {
  default = ""
}

variable "instance_type" {
  default = ""
}

variable "instance_name" {
  default = "terraform-testing"
}

# ECS OS info
variable "os_name" {
  default = "centos"
}

variable "image_name_regex" {
  default = "^CentOS\\s+7\\.3\\s+64\\w*"
}

variable "cvm_password" {
  default = "Tencent-test"
}

variable "count_format" {
  default = "%02d"
}

# RDS info
variable "rds_name" {
    deafalt = "tf-rds"  
}
