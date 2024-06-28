resource "esxi_vswitch" "physswitch" {
  name = "PHYSSWITCH"
  uplink {
    name = "vmnic1"
  }
}

resource "esxi_portgroup" "phys" {
  name = "PHYSLAN"
  vswitch = esxi_vswitch.physswitch.name
  depends_on = [
    esxi_vswitch.physswitch
 ]
}
