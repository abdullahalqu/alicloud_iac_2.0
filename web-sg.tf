resource "alicloud_security_group" "web" {
  name        = "web-sg"
  description = "this is http sg as a http traffic"
  vpc_id      = alicloud_vpc.vpc.id
}
resource "alicloud_security_group_rule" "allow_http" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "80/80"
  security_group_id = alicloud_security_group.web.id
  cidr_ip =  "10.0.0.0/8"

#   source_security_group_id = alicloud_security_group.bastion.id
}

resource "alicloud_security_group_rule" "allow_web_ssh_form_bastion" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "22/22"
  security_group_id = alicloud_security_group.web.id
  source_security_group_id = alicloud_security_group.bastion.id
  # cidr_ip =  "0.0.0.0/0"
}