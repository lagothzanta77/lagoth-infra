data "template_file" "cloud-userdata_win" {
  template			= file("borgdc_files/winuserdata.tpl")
  vars = {
    HOSTNAME			= var.dc1_name
    ROUTER			= var.phys_gateway
    DCIP			= local.dc1winip
    DCIPPURE			= var.dc1_winip_pure
    DCNETWORK			= var.dc_network
    DCNAME			= var.dc_name
    ETHNAME			= var.dc_ethname
    DHCPSTART			= var.dc_dhcpstart
    DHCPEND			= var.dc_dhcpend
    DNSPTR			= var.dc_ptrzone
    NETSUBNET			= var.dc_subnet2
  }
}

data "template_file" "cloud-metadata_win" {
    template = file("borgdc_files/winmetadata.tpl")
    vars			= {
      ipAddress			= local.dc1winip
      gateway			= var.phys_gateway
      nameserver		= var.phys_ns
      macaddr			= var.dc1_mac
      ethname			= var.dc_ethname
      MYID			= var.dc1_name
      MYHOSTNAME		= var.dc1_name
    }
}

resource "esxi_guest" "borgdc1" {
  numvcpus			= "2"
  memsize			= "2048"
  guest_name			= var.dc1_name
  boot_firmware			= "efi"
  disk_store			= var.main_store
  virthwver			= var.virthw
  guestos			= var.winsrv

  boot_disk_type		= "thin"
  boot_disk_size		= "40"

  power				= "on"

  clone_from_vm			= var.wintemp_guestname

  guestinfo			= {
    "metadata.encoding"		= "gzip+base64"
    "metadata"			= base64gzip(data.template_file.cloud-metadata_win.rendered)
    "userdata.encoding"		= "gzip+base64"
    "userdata"			= base64gzip(data.template_file.cloud-userdata_win.rendered)
  }

  network_interfaces {
       nic_type			= "e1000e"
       virtual_network		= esxi_portgroup.phys.name
       mac_address		= var.dc1_mac
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
    virtual_disk_id		= esxi_virtual_disk.dcdisk.id
    slot			= "0:1"
  }

  depends_on			= [
    esxi_portgroup.phys,
    esxi_guest.wintemplate
 ]

}
