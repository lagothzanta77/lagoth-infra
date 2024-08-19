data "template_file" "cloud-linuserdata" {
  template			= file("borg_linsrv_files/userdata.tpl")
  vars = {
    HOSTNAME			= var.lin1_name
    SSHPUB			= local.sshpubkey
    NS				= var.dc1_winip_pure
    DCKEY			= filebase64("inputfiles/dc.key")
    WSMANFILE			= filebase64("borg_linsrv_files/wsman.ps1")
    CONFIGFILE			= filebase64("borg_linsrv_files/borgconfig.sh")
    REMOTEPSFILE		= filebase64("borg_linsrv_files/remoteps.ps1")
    KERBEROSFILE		= filebase64("borg_linsrv_files/keytab.sh")
    ADMINUSER			= var.dc_admin
    BORGADMIN			= var.linadmin
  }
}

data "template_file" "cloud-linmetadata" {
    template			= file("borg_linsrv_files/metadata.tpl")
    vars = {
      ipAddress			= local.linsrv1ip
      gateway			= var.phys_gateway
      nameserver		= var.dc1_winip_pure
    }
}

resource "esxi_guest" "borglinsrv1" {

  memsize			= "1024"
  numvcpus			= "1"
  power				= "on"

  guest_name			= var.lin1_name
  boot_firmware			= "efi"
  disk_store			= var.main_store
  guestos			= var.linsrv

  boot_disk_type		= "thin"
  boot_disk_size		= "10"

  network_interfaces {
    virtual_network		= esxi_portgroup.phys.name
    nic_type			= "vmxnet3"
  }

  clone_from_vm			= var.lintemp_guestname

  guestinfo			= {
    "metadata.encoding"		= "gzip+base64"
    "metadata"			= base64gzip(data.template_file.cloud-linmetadata.rendered)
    "userdata.encoding"		= "gzip+base64"
    "userdata"			= base64gzip(data.template_file.cloud-linuserdata.rendered)
  }

  depends_on			= [
    esxi_guest.lintemplate,
    esxi_guest.borgwindocker1
 ]

  connection {
    type			= "ssh"
    user			= var.linadmin
    private_key			= file("inputfiles/sshkey/borgadmin.key")
    host			= var.lin1_ip_pure
  }


  provisioner "file" {
    source			= "inputfiles/dc.key"
    destination			= "/tmp/dc.key"
  }

  provisioner "remote-exec" {

    when			= create
    inline			= [
	"until [ -e /srv/${var.linadmin}.done ]",
	"do",
	"sleep 20",
	"done",
	"sudo mv /tmp/dc.key /srv/dc.key",
	"sudo bash /srv/keytab.sh ${var.linadmin} ${local.keytabfile} ${local.dcadmin}",
    ]
  }

}

