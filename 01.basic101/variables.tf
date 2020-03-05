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
  default = "192.168.0.0/16"
}

# VSwitch Info
variable "web_cidr" {
  default = "192.168.1.0/24"
}

variable "db_cidr" {
  default = "192.168.2.0/24"
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

variable "password" {
  default = "Tencent-test"
}

# RDS info
variable "rds_name" {
  default = "tf-rds"  
}

# MYSQL info

# MY SQL default engine is 5.7 (selected 5.5, 5.6)
variable "dbengine" {
  default = "5.6"
}
