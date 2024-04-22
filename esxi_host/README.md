# VMware ESX(i) Automated install

This system offers the following features:

  * VMware ESX(i) 6.7 
  * Enabled SSH only via [Terramaster](../terraform_cli_vm/README.md) system
  * Enabled WEB UI via [Terramaster](../terraform_cli_vm/README.md) system
  * Enabled iSCSI Software Interface
  * Pre-configured virtual switch for iSCSI subnet
  * Pre-configured port group for VMs
  * Autoconfigured Management Network
  * Disabled ipv6
  * Pre-installed update patch
  * Disabled Internet connection for ESXi Host
  * Preconfigured a Linux VM as Template

## Requirements

  * Hypervisor (KVM with VDE recommended)
  * Free disk space :-)
  * [Terramaster VM](../terraform_cli_vm/README.md)

## Installation commands

### Initialisation and first install

    bash generiso.sh;sync;sleep 1;bash kvm_terraform.sh

### System start command

    bash kvm_terraform.sh

### Login (passwords are disabled)

    ssh -p SSHTUNNELPORT root@127.0.0.1

**This repo is only a so-called demo version so some folders are not available.**
(for example borg_library)

If you are interested in this topic you can search me on:

  * [linkedin](https://hu.linkedin.com/in/zoltan-foldi-663797209?trk=people-guest_people_search-card)

## Sources

[VMware ESX(i)](https://www.vmware.com/products/esxi-and-esx.html)

[Scripted VMware ESXI installation](https://docs.vmware.com/en/VMware-vSphere/6.7/com.vmware.esxi.install.doc/GUID-00224A32-C5C5-4713-969A-C50FF4DED8F8.html)

[Borg :-)](https://en.wikipedia.org/wiki/Borg)
