variable "dc1_name" {
  default = "borgdc1"
}

variable "dc_subnet1" {
  default = "24"
}

variable "dc_subnet2" {
  default = "255.255.255.0"
}

variable "dc1_winip_pure" {
  default = "192.168.0.51"
}

variable "dc_network" {
  default = "192.168.0.0/24"
}

variable "dc_ptrzone" {
  default = "0.168.192.in-addr.arpa"
}

variable "dc1_mac" {
  default = "00:50:56:3d:13:d9"
}

variable "dc_name" {
  default = "UNIMATRIX.LOCAL"
}

variable "dc_ethname" {
  default = "Ethernet0"
}

variable "dc_dhcpstart" {
  default = "192.168.0.100"
}

variable "dc_dhcpend" {
  default = "192.168.0.150"
}

variable "dc_admin" {
  default = "Administrator"
}
