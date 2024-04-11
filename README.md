# Debian Automated install

This system offers the following features:

  * Debian bookworm
  * Authentication via SSH key for a single user
  * Preconfigured nft firewall rules
  * Manageable virtual machine via telnet and spice
  * Disabled ipv6
  * Disabled user passwords (include root)
  * Pre-installed Terraform CLI
  * Pre-installed kubectl CLI

## Requirements

  * Hypervisor (KVM with VDE recommended)
  * Free space :-)

## Installation commands

### Initialization and first install

    `bash generiso.sh;sync;sleep 1;bash kvm_terraform.sh`

### System start command

    `bash kvm_terraform.sh`

### Login (passwords are disabled)

    `ssh -i sshkeys/USERNAME.sshkey USERNAME@IPV4ADDRESS`

**This repo is only a so-called demo version so some folder - for example borg_library - is not available.**

If you are interested in this topic you can search me on [linkedin](https://hu.linkedin.com/in/zoltan-foldi-663797209?trk=people-guest_people_search-card)

## Sources

[Debian](https://www.debian.org/)

[Terraform](https://www.terraform.io/)

[Kubernetes](https://kubernetes.io/)

[Debian Preseed Install Options](https://people.debian.org/~plessy/DebianInstallerDebconfTemplates.html)

[Debian installer Boot parameters](https://www.debian.org/releases/buster/s390x/ch05s02.en.html)

[Borg :-)](https://en.wikipedia.org/wiki/Borg)
