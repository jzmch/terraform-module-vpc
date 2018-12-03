locals {
  common_tags = {
    Project     = "${var.project_name}"
    Environment = "${var.environment}"
  }
}

variable "project_name" {
  type = "string"
}

variable "environment" {
  type = "string"
}

variable "vpc_cidr_block" {
  type = "string"
}

variable "public_subnet_cidr_blocks" {
  type    = "list"
  default = []
}

variable "private_subnet_cidr_blocks" {
  type    = "list"
  default = []
}

variable "nat_gateway_elastic_ips" {
  type    = "list"
  default = []
}

variable "create_elastic_ips" {
  default = true
}

variable "enable_dns_hostnames" {
  default = true
}

variable "enable_dns_support" {
  default = true
}

variable "additional_vpc_tags" {
  type = "map"
  default = {}
}

variable "additional_igw_tags" {
  type = "map"
  default = {}
}

variable "additional_nat_gw_tags" {
  type = "map"
  default = {}
}

variable "additional_private_subnet_tags" {
  type = "map"
  default = {}
}

variable "additional_private_route_table_tags" {
  type = "map"
  default = {}
}

variable "additional_public_subnet_tags" {
  type = "map"
  default = {}
}

variable "additional_public_route_table_tags" {
  type = "map"
  default = {}
}