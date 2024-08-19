resource "esxi_guest" "lintemplate" {

  virthwver			= var.virthw
  numvcpus			= "2"
  memsize			= "1024"
  guest_name			= var.lintemp_guestname
  boot_firmware			= "efi"
  disk_store			= var.temp_datastore
  guestos			= var.linsrv

  boot_disk_type		= "thin"
  boot_disk_size		= "10"

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
    source			= "000_borglin_template_files/vmfix.sh"
    destination			= "${var.dest_linshscript}"
  }

  provisioner "remote-exec" {
    when			= create
    inline			= [ 
	"sh ${var.dest_linshscript} ${local.linvmxname} ${local.linisoname} ${self.guest_name} ${esxi_portgroup.phys.name}"
    ]
  }
}
