# alicloud_iac


```
alicloud_nlb_load_balancer-http-dns_name = "nlb-5zi8828hm69hahjh9s.me-central-1.nlb.aliyuncs.com"
alicloud_nlb_server_group-http-health_check = tolist([
  {
    "health_check_connect_port" = 0
    "health_check_connect_timeout" = 5
    "health_check_domain" = "$SERVER_IP"
    "health_check_enabled" = true
    "health_check_http_code" = tolist([
      "http_2xx",
      "http_3xx",
      "http_4xx",
    ])
    "health_check_interval" = 10
    "health_check_type" = "TCP"
    "health_check_url" = ""
    "healthy_threshold" = 2
    "http_check_method" = "GET"
    "unhealthy_threshold" = 2
  },
])
bastion_public_ip = "8.213.38.185"
db_private_ip = "10.0.2.90"
redis_private_ip = "10.0.2.91"
web_server_private_ips = [
  "10.0.2.92",
  "10.0.2.93",

```