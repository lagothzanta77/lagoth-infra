data "template_file" "cloud-userdata" {
  template = file("userdata.tpl")
  vars = {
    HOSTNAME = var.vm_hostname
    HELLO    = "This system has been assimilated!"
    HTML_FILE = base64encode(file("/home/terramaster/terraform/borgvm01_files/borg_image.html"))
    TOPOLOGY_FILE = filebase64("/home/terramaster/terraform/borgvm01_files/borg_image.png")
  }
}

data "template_file" "cloud-metadata" {
    template = file("metadata.tpl")
    vars = {
      ipAddress = var.vm_ip
      gateway = var.vm_gateway
      nameserver = var.nameserver
    }
}

resource "esxi_guest" "borgvm01" {
  guest_name = var.vm_name
  boot_firmware = "efi"
  disk_store = "borgdatastore"
  guestos    = "debian10-64"

  boot_disk_type = "thin"
  boot_disk_size = "10"

  memsize            = "2048"
  numvcpus           = "2"
  power              = "off"

  ovf_source        = "/home/terramaster/mount/volumes/borgosstore/borgLinTemplate/borgLinTemplate.vmx"

  network_interfaces {
    virtual_network = var.vm_portgroup
  }

  guestinfo = {
    "metadata.encoding" = "gzip+base64"
    "metadata"          = base64gzip(data.template_file.cloud-metadata.rendered)
    "userdata.encoding" = "gzip+base64"
    "userdata"          = base64gzip(data.template_file.cloud-userdata.rendered)
  }
}
