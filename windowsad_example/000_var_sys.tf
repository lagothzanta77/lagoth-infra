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
  sensitive = true
}

variable "dest_workaround_script" {
  default = "/vmfs/volumes/borgosstore/adminscripts/cpumem_workaround.sh"
}

variable "esxi_config_dir" {
  default = "/vmfs/volumes/borgosstore/adminscripts/"
}

variable "esxi_config_script" {
  default = "/vmfs/volumes/borgosstore/adminscripts/esxi_config.sh"
}

variable "auto_vm_script" {
  default = "/vmfs/volumes/borgosstore/adminscripts/vm_autostartconf.sh"
}

variable "testdc_script" {
  default = "/vmfs/volumes/borgosstore/adminscripts/testdc.sh"
}

variable "main_store" {
  default = "borgdatastore"
}
