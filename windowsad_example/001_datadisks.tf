resource "esxi_virtual_disk" "dcdisk" {
  virtual_disk_disk_store	= var.main_store
  virtual_disk_dir		= "Data disks"
  virtual_disk_name		= "dcdisk.vmdk"
  virtual_disk_size		= 10
  virtual_disk_type		= "thin"

  depends_on			= [
    esxi_vswitch.physswitch
 ]

}

resource "esxi_virtual_disk" "dockerdisk" {
  virtual_disk_disk_store	= var.main_store
  virtual_disk_dir		= "Data disks"
  virtual_disk_name		= "dockerdisk.vmdk"
  virtual_disk_size		= 20
  virtual_disk_type		= "thin"

  depends_on			= [
    esxi_vswitch.physswitch
 ]

}
