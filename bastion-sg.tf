
resource "alicloud_security_group" "bastion" {
  name        = "bastion-sg"
  description = "this is bastion sg as a jump server for ssh"
  vpc_id      = alicloud_vpc.vpc.id
}
resource "alicloud_security_group_rule" "allow_ssh_to_bastion" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "22/22"
  security_group_id = alicloud_security_group.bastion.id
  cidr_ip           = "0.0.0.0/0"
}