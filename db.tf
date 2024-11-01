resource "alicloud_instance" "ecs_db" {
  # cn-beijing
  availability_zone = data.alicloud_zones.default.zones.0.id
  security_groups   = [alicloud_security_group.db.id]

  host_name = "db"
  instance_type              = var.instance_type
  system_disk_category       = "cloud_essd"
  image_id                   = var.image_id
  instance_name              = "ecs_redis"
  internet_charge_type       = "PayByTraffic"
  instance_charge_type       = "PostPaid"
  vswitch_id                 = alicloud_vswitch.private_vswitch.id
  internet_max_bandwidth_out = 0
  key_name = alicloud_key_pair.publickey.key_pair_name


  data_disks {
    name        = "public-disk"
    size        = 40
    category    = "cloud_essd"
  }

  user_data = base64encode(file("db-init.yml"))

}

output "db_private_ip" {
  value = alicloud_instance.ecs_db.private_ip
}