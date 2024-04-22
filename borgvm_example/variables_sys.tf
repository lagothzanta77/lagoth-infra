variable "esxi_hostname" {
  default = "172.30.100.2"
}

variable "esxi_hostport" {
  default = "22"
}

variable "esxi_hostssl" {
  default = "443"
}

variable "esxi_username" {
  default = "terramaster"
}

variable "esxi_password" {
  sensitive   = true
}
