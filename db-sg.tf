
resource "alicloud_security_group" "db" {
  name        = "db-sg"
  description = "this is db sg"
  vpc_id      = alicloud_vpc.vpc.id
}


resource "alicloud_security_group_rule" "allow_db_ssh_form_bastion" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "22/22"
  security_group_id = alicloud_security_group.db.id
  source_security_group_id = alicloud_security_group.bastion.id
}


resource "alicloud_security_group_rule" "allow_sql_connection" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "3306/3306"
  security_group_id = alicloud_security_group.db.id
  source_security_group_id = alicloud_security_group.web.id
#   cidr_ip =  "0.0.0.0/0"
}

