# Debian Automated install

This system offers the following features:

  * Debian bookworm
  * Authentication via SSH key for a single user only from the 
Terraform CLI system
  * Pre-configured nft firewall rules
  * Manageable virtual machine via telnet and spice
  * Disabled ipv6
  * Disabled user passwords (include root)
  * +3 network interface (for iSCSI traffic)
  * +3 virtual SCSI disks for iSCSI with different size
  * +1 empty virtual SCSI port (for hotswapping)
  * Pre-installed targetcli-fb
  * Pre-installed and configured iSCSI target

## Requirements

  * Hypervisor (KVM with VDE recommended)
  * Very large free space :-)
  * [Terramaster VM](../terraform_cli_vm/README.md) (for SSH tunnel)
  * Pre-defined iSCSI Password in `generiso.iso`

## Installation commands

### Initialization and first install

    bash generiso.sh;sync;sleep 1;bash kvm_terraform.sh

### System start command

    bash kvm_terraform.sh

### Login (passwords are disabled)

    ssh -i sshkeys/USERNAME.sshkey -p SSHTUNNELPORT USERNAME@127.0.0.1

**This repo is only a so-called demo version so some folder - for**
**example borg_library - is not available.**

## More Information

  * BORG_ISCSI_PWD environment variable can be used as ISCSI password
  * The smallest extra disk will be used for ISO images
  * The largest extra disk will be used for DATA disks
  * The last extra disk will be used for OS system disks
  * These disks are available in LVM so you can scale them later very easy
  * If you are interested in this topic you can find me on [linkedin](https://hu.linkedin.com/in/zoltan-foldi-663797209?trk=people-guest_people_search-card)

## Sources

[Debian](https://www.debian.org/)

[LIO](https://wiki.debian.org/SAN/iSCSI/LIO)

[Debian Preseed Install Options](https://people.debian.org/~plessy/DebianInstallerDebconfTemplates.html)

[Debian installer Boot parameters](https://www.debian.org/releases/buster/s390x/ch05s02.en.html)

[Borg :-)](https://en.wikipedia.org/wiki/Borg)
