variable "temp_isostore" {
  default = "borgisostore"
}

variable "lin_isofname" {
  default = "borglin.iso"
}

variable "win_isofname" {
  default = "borg_win2k22.iso"
}

variable "temp_datastore" {
  default = "borgosstore"
}

variable "lintemp_guestname" {
  default = "borgLinTemplate"
}

variable "wintemp_guestname" {
  default = "borgWinTemplate"
}

variable "dest_linshscript" {
  default = "/vmfs/volumes/borgosstore/adminscripts/vmfix.sh"
}

variable "dest_winshscript" {
  default = "/vmfs/volumes/borgosstore/adminscripts/winvmfix.sh"
}

variable "complete_isofiles" {
  default = "/vmfs/volumes/borgisostore/assimilated"
}

variable "virthw" {
  default = "19"
}

variable "winsrv" {
  default = "windows2019srvNext-64"
}

variable "linsrv" {
  default = "debian11-64"
}
