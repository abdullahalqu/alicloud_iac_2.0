# Create a new ECS instance for VPC
resource "alicloud_vpc" "vpc" {
  vpc_name   = "VPC"
  cidr_block = "10.0.0.0/8"
}

data "alicloud_zones" "default" {
  available_disk_category     = "cloud_efficiency"
  available_resource_creation = "VSwitch"
}

resource "alicloud_vswitch" "load_balance_vswitch" {
  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = "10.0.3.0/24"
  zone_id      = data.alicloud_zones.default.zones.1.id
  vswitch_name = "vswtich for load balancer"
}

resource "alicloud_vswitch" "public_vswitch" {
  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = "10.0.1.0/24"
  zone_id      = data.alicloud_zones.default.zones.0.id
  vswitch_name = "public vswitch"
}


resource "alicloud_vswitch" "private_vswitch" {
  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = "10.0.2.0/24"
  zone_id      = data.alicloud_zones.default.zones.0.id
  vswitch_name = "private vswitch"
}

resource "alicloud_nat_gateway" "default" {
  vpc_id           = alicloud_vpc.vpc.id
  nat_gateway_name = "NAT"
  payment_type     = "PayAsYouGo"
  vswitch_id       = alicloud_vswitch.public_vswitch.id
  nat_type         = "Enhanced"
}
resource "alicloud_eip_address" "nat" {
  address_name = "nat eip"
  netmode = "public"
  internet_charge_type = "PayByTraffic"
  payment_type = "PayAsYouGo"
}

resource "alicloud_eip_association" "nat_ip" {
  allocation_id = alicloud_eip_address.nat.id
  instance_id   = alicloud_nat_gateway.default.id
}

resource "alicloud_snat_entry" "nat_entry" {
  snat_table_id     = alicloud_nat_gateway.default.snat_table_ids
  source_vswitch_id = alicloud_vswitch.private_vswitch.id
  snat_ip           = alicloud_eip_address.nat.ip_address
}

resource "alicloud_route_table" "nat_rout_table" {

  description      = "routing private ecs to nat"
  vpc_id           = alicloud_vpc.vpc.id
  route_table_name = "nat route table"
  associate_type   = "VSwitch"
}

resource "alicloud_route_entry" "nat_rout_entry" {
  route_table_id        = alicloud_route_table.nat_rout_table.id
  destination_cidrblock = "0.0.0.0/0"
  nexthop_type          = "NatGateway"
  nexthop_id            = alicloud_nat_gateway.default.id
}

resource "alicloud_route_table_attachment" "attach_private_vswitch" {
  vswitch_id     = alicloud_vswitch.private_vswitch.id
  route_table_id = alicloud_route_table.nat_rout_table.id
}