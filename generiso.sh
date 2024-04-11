#!/bin/bash

# include library

. ../borg_library/borg_preseed_library.sh

# Variables

## This file must exist
ORIGINAL_ISO="debianinstall.iso"
NICMODULES_PKG="pool/main/l/linux-signed-amd64"
NIC_PKGNAME=""
NEW_ISO="terramaster.iso"
TMPDIR=mytemper
BORG_TF_CLI_USER="terramaster"
# terraform_ip must be in this format: ipv4_address/netmask
TERRAFORM_IP="192.168.0.221/24"
# These devices must be available
# BORG_DNS can be set via system environment : export BORG_DNS=....
if [ "$BORG_DNS" = "" ];then
    BORG_DNS="1.1.1.1"
fi
BORG_ROUTER="192.168.0.254"
BORG_SYSDISK="/dev/vda"

### WARNING: Limitation: The current country setting is Hungary/Europe. If you want to change this, please modify the preseed template file. ###

echo "This is a BORG assimilation :-) script to create a Debian installer with Terraform CLI and Kubectl binaries from scratch."

borg_precond
borg_sshkey_gen $BORG_TF_CLI_USER
borg_ipchecker "$TERRAFORM_IP"

echo "Assimilating the Debian installer to create a Linux system for Terraform CLI..."
borg_prepare
sync

borg_late_script "$TMPDIR" "$ORIGINAL_ISO" "../borg_templates/late_script_template.sh" "$BORG_TF_CLI_USER" "assimilator"
borg_vminfo "$TMPDIR" "$BORG_TERRAFORMIP" "$BORG_NETMASK" "$BORG_ROUTER" "$BORG_DNS" "$BORG_SYSDISK" "$BORG_TF_CLI_USER" "$SCR_ENDFILE"
borg_grub_gen "$TMPDIR"
borg_iso_changer "$TMPDIR" "$NEW_ISO"
echo "...The assimilation is complete. The assimilated image is $NEW_ISO. Your user name will be: $BORG_TF_CLI_USER"

echo "Assimilating the KVM bash script to modify the ISO image..."
sed -e "s@BORG_ISO@$NEW_ISO@g" 		 \
    -e "s@BORG_USER@$BORG_TF_CLI_USER@g" \
    -e "s@BORG_IP@$BORG_TERRAFORMIP@g" ../borg_templates/kvm_template.sh > kvm_terraform.sh
echo "...It has been completed. You can run it with: bash kvm_terraform.sh"
echo "By the way, you have to set up your virtual distributed ethernet subsystem before you start the KVM virtual machine."
