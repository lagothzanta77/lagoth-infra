variable "vm_name" {
  default = "borgvm01"
}

variable "vm_hostname" {
  default = "borgvm01"
}

variable "vm_ip" {
  default = "192.168.0.111/24"
}

variable "vm_gateway" {
  default = "192.168.0.254"
}

variable "nameserver" {
  sensitive = true
}
