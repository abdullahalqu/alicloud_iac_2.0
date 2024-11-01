resource "alicloud_nlb_load_balancer" "http" {
  load_balancer_name = "http-ld"
  load_balancer_type = "Network"
  address_type       = "Internet"
  address_ip_version = "Ipv4"
  vpc_id             = alicloud_vpc.vpc.id
  # security_group_ids = alicloud_instance.nlb.id

  zone_mappings {
    vswitch_id = alicloud_vswitch.load_balance_vswitch.id
    zone_id    = alicloud_vswitch.load_balance_vswitch.zone_id
  }
  zone_mappings {
    vswitch_id = alicloud_vswitch.public_vswitch.id
    zone_id    =  alicloud_vswitch.public_vswitch.zone_id
  }
}

resource "alicloud_nlb_server_group" "http" {
  server_group_name        = "http-server-group"
  server_group_type        = "Instance"
  vpc_id                   = alicloud_vpc.vpc.id
  scheduler                = "rr"
  protocol                 = "TCP"
  connection_drain_enabled = true
  connection_drain_timeout = 60
  address_ip_version       = "Ipv4"
  health_check {
    health_check_enabled         = true
    health_check_type            = "TCP"
    health_check_connect_port    = 0
    healthy_threshold            = 2
    unhealthy_threshold          = 2
    health_check_connect_timeout = 5
    health_check_interval        = 10
    http_check_method            = "GET"
    health_check_http_code       = ["http_2xx", "http_3xx", "http_4xx"]
  }
}

resource "alicloud_nlb_server_group_server_attachment" "http" {
  count = length(alicloud_instance.ecs_web)
  server_type     = "Ecs"
  server_id       = alicloud_instance.ecs_web[count.index].id
  port            = 80
  server_group_id = alicloud_nlb_server_group.http.id
  weight          = 100
}

resource "alicloud_nlb_listener" "http" {
  listener_protocol      = "TCP"
  listener_port          = "80"
  load_balancer_id       = alicloud_nlb_load_balancer.http.id
  server_group_id        = alicloud_nlb_server_group.http.id
  idle_timeout           = "900"
  proxy_protocol_enabled = "false"
  cps                    = "0"
  mss                    = "0"
}

output "alicloud_nlb_server_group-http-health_check" {
  value = alicloud_nlb_server_group.http.health_check
}

output "alicloud_nlb_load_balancer-http-dns_name" {
  value = alicloud_nlb_load_balancer.http.dns_name
}