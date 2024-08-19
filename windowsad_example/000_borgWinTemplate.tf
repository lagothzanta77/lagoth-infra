resource "esxi_guest" "wintemplate" {

  guest_name			= var.wintemp_guestname
  boot_firmware			= "efi"
  disk_store			= var.temp_datastore
  virthwver			= var.virthw
  guestos			= var.winsrv

  boot_disk_type		= "thin"
  boot_disk_size		= "40"

  memsize			= "2048"
  numvcpus			= "4"
  power				= "off"

  depends_on 			= [
    terraform_data.searching_isofiles
 ]

  connection {
    type			= "ssh"
    user			= var.esxi_username
    password			= var.esxi_password
    host			= var.esxi_hostname
  }

  provisioner "file" {
    source			= "000_borgwin_template_files/winvmfix.sh"
    destination			= "${var.dest_winshscript}"
}

  provisioner "remote-exec" {
    when			= create
    inline			= [ 
	"sh ${var.dest_winshscript} ${local.winvmxname} ${local.winisoname} ${self.guest_name} ${esxi_portgroup.phys.name}"
    ]
  }
}
