resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr_block}"
  enable_dns_support   = "${var.enable_dns_support}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"

  tags = "${merge(local.common_tags, map("Name", "${var.project_name}-vpc"), var.additional_vpc_tags)}"
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags = "${merge(local.common_tags, map("Name", "${var.project_name}-igw"), var.additional_igw_tags)}"
}
