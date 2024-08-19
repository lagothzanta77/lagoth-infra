resource "terraform_data"  "searching_isofiles" {
   connection {
     type			= "ssh"
     user			= var.esxi_username
     password			= var.esxi_password
     host			= var.esxi_hostname
  }
 
   provisioner "remote-exec" {
     inline			= [
	"echo 'Waiting for iso files...'",
	"until [ -f ${var.complete_isofiles} ];do sleep 45;done"
     ]
   }
 
   depends_on			= [
     terraform_data.config_esxi
  ]

}
