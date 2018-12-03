resource "aws_subnet" "public" {
  count                   = "${length(var.public_subnet_cidr_blocks)}"
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.public_subnet_cidr_blocks[count.index]}"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = true

  tags = "${merge(local.common_tags, map("Name", "${var.project_name}-public-subnet-${count.index + 1}"), var.additional_public_subnet_tags)}"
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }

  tags = "${merge(local.common_tags, map("Name", "${var.project_name}-public-route-table"), var.additional_public_route_table_tags)}"
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.public_subnet_cidr_blocks)}"
  route_table_id = "${aws_route_table.public.id}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
}

resource "aws_eip" "nat_gateway_ip" {
  count = "${var.create_elastic_ips ? length(var.public_subnet_cidr_blocks) : 0}"
  vpc   = true
}

resource "aws_nat_gateway" "with_created_eips" {
  depends_on    = ["aws_eip.nat_gateway_ip"]
  count         = "${var.create_elastic_ips ? length(var.public_subnet_cidr_blocks) : 0}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
  allocation_id = "${element(aws_eip.nat_gateway_ip.*.id, count.index)}"

  tags = "${merge(local.common_tags, map("Name", "${var.project_name}-nat-gw-${count.index + 1}"), var.additional_nat_gw_tags)}"
}

resource "aws_nat_gateway" "without_created_eips" {
  count         = "${var.create_elastic_ips ? 0 : length(var.nat_gateway_elastic_ips)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
  allocation_id = "${element(var.nat_gateway_elastic_ips, count.index)}"

  tags = "${merge(local.common_tags, map("Name", "${var.project_name}-nat-gw-${count.index + 1}"), var.additional_nat_gw_tags)}"
}
