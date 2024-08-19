# Automated Demo Infrastructure Installation

The following systems will be installed automatically:

  * Debian Bookworm with Terraform CLI and kubectl binaries
  * Debian Bookworm as pre-configured iSCSI target
  * VMware ESX(i) 6.7 standalone host

## Requirements

  * Hypervisor (KVM with VDE recommended)
  * Free disk space :-)
  * `isos` folder for ISO files
  * `esxi_update` folder for ESXI Update ZIP

## Installation Commands (Optional Parameter with DNS Server)

    bash lagoth-infra-demo.sh "192.255.255.255"

## More Information

[Terramaster System](terraform_cli_vm/README.md)

[iSCSI target System](iscsi_target/README.md)

[VMware ESX(i) System](esxi_host/README.md)

[Terraform Provider ESXI plugin (by josenk)](https://github.com/josenk/terraform-provider-esxi)

## Extras

  * [Debian ISO installer to create a template from scratch](borglin_template/generiso.sh)
  * [Windows Server ISO installer to create a template from scratch](borgwin_template/README.md)
  * [Automated Install of a small Windows AD environment from scratch](windowsad_example/README.md) 

## Videos

  * [Youtube video links of the setup and usage of this infrastructure](install_demo.md)

## Known Bugs

  * The `lowmem` boot parameter for Debian can cause `console-setup-linux` to become confused

## Clean Code Guidelines

  * Max. length of a line in a bash script: 100
  * Simple conditional permitted in one line
  * Indentation of a bash script: `TAB`
