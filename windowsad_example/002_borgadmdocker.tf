data "template_file" "cloud-userdata_windocker" {
  template			= file("borgadmdckr_files/winuserdata.tpl")
  vars 				= {
    HOSTNAME			= var.windocker1_name
    DCNAME			= var.dc_name
    NSNAME			= var.dc1_name
    ETHNAME			= var.dc_ethname
    ADMPORT			= var.admincenter_port
    DCADMIN			= var.dc_admin
  }
}

data "template_file" "cloud-metadata_windocker" {
    template 			= file("borgadmdckr_files/winmetadata.tpl")
    vars			= {
      ipAddress			= local.docker1winip
      gateway			= var.phys_gateway
      nameserver		= var.dc1_winip_pure
      macaddr			= var.windocker1_mac
      ethname			= var.dc_ethname
      MYID			= var.windocker1_name
      MYHOSTNAME		= var.windocker1_name
    }
}

resource "esxi_guest" "borgwindocker1" {
  numvcpus			= "1"
  memsize			= "2048"
  guest_name			= var.windocker1_name
  boot_firmware			= "efi"
  disk_store			= var.main_store
  virthwver			= var.virthw
  guestos			= var.winsrv

  boot_disk_type		= "thin"
  boot_disk_size		= "20"

  power				= "on"

  clone_from_vm			= var.wintemp_guestname

  guestinfo			= {
    "metadata.encoding"		= "gzip+base64"
    "metadata"			= base64gzip(data.template_file.cloud-metadata_windocker.rendered)
    "userdata.encoding"		= "gzip+base64"
    "userdata"			= base64gzip(data.template_file.cloud-userdata_windocker.rendered)
  }

  network_interfaces {
       nic_type			= "e1000e"
       virtual_network		= esxi_portgroup.phys.name
       mac_address		= var.windocker1_mac
  }

  provisioner "remote-exec" {

    connection {
      type			= "ssh"
      user			= var.esxi_username
      password			= var.esxi_password
      host			= var.esxi_hostname
    }

    when			= create
    inline			= [
      "sh ${var.testdc_script} ${self.guest_name} ${join("", [
	    "${self.guest_name}",
	    ".",
	    "${var.dc_name}"])}"
    ]

  }

  virtual_disks {
    virtual_disk_id		= esxi_virtual_disk.dockerdisk.id
    slot			= "0:1"
  }

  depends_on			= [
    esxi_guest.borgdc1

 ]

}
