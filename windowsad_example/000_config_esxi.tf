resource "terraform_data"  "config_esxi" {

  connection {
    type			= "ssh"
    user			= var.esxi_username
    password			= var.esxi_password
    host			= var.esxi_hostname
  }

  provisioner "file" {
    source			= "000_config_esxi_files/"
    destination			= "${var.esxi_config_dir}"
  }

  provisioner "remote-exec" {
    inline			= [
	"sh ${var.esxi_config_script}"
    ]
  }

  depends_on			= [
    esxi_vswitch.physswitch
  ]

}
