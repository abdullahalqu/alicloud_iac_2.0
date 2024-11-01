variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "image_id" {
  default = "ubuntu_24_04_x64_20G_alibase_20240812.vhd"
}
variable "instance_type" {
  default = "ecs.g6.large"
}