resource "alicloud_key_pair" "publickey" {
  key_pair_name   = "ssh-key"
  key_file = "ssh-key.pem"
}