
resource "alicloud_security_group" "redis" {
  name        = "redis-sg"
  description = "this is redis sg"
  vpc_id      = alicloud_vpc.vpc.id
}


resource "alicloud_security_group_rule" "allow_redis_ssh_form_bastion" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "22/22"
  security_group_id = alicloud_security_group.redis.id
  source_security_group_id = alicloud_security_group.bastion.id
}


resource "alicloud_security_group_rule" "allow_redis_connection" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "6379/6379"
  security_group_id = alicloud_security_group.redis.id
  source_security_group_id = alicloud_security_group.web.id
#   cidr_ip =  "0.0.0.0/0"
}

