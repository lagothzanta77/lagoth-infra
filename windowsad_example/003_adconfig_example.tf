resource "terraform_data"  "ad_config" {

# The ad_provider can be used instead of this method, but it doesn't support Kerberos authentication (only WinRM user/password).

  connection {
    type			= "ssh"
    user			= var.linadmin
    private_key			= file("inputfiles/sshkey/borgadmin.key")
    host			= var.lin1_ip_pure
  }

  provisioner "file" {
    source			= "003_adconfig_example_files"
    destination			= "/home/${var.linadmin}/adconfig/"
  }

  provisioner "remote-exec" {
    inline			= [
	"kinit -kt ${local.keytabfile} ${local.dcadmin}",
	"bash /srv/registerdns.sh ${var.dc1_name} >/home/${var.linadmin}/adconfig/adconfig.log",
	"pwsh /srv/remoteps.ps1 ${var.dc1_name}.${var.dc_name} /home/${var.linadmin}/adconfig/adconfig.ps1 >/home/${var.linadmin}/adconfig/adconfig.log",
	"pwsh /srv/remoteps.ps1 ${var.windocker1_name}.${var.dc_name} /home/${var.linadmin}/adconfig/dockerinstall.ps1 >>/home/${var.linadmin}/adconfig/adconfig.log",
	"kdestroy"
    ]
  }

  depends_on			= [
    esxi_guest.borglinsrv1
  ]

}
