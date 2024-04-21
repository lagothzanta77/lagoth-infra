#!/bin/bash

. ../borg_library/borg_preseed_library.sh

### Variables start
## This file must exist
ORIGINAL_ISO="../isos/debianinstall.iso"
NEW_ISO="../isos/iscsimaster.iso"
TMPDIR=mytemper
BORG_TF_CLI_USER="storagemaster"
# terraform_ip must be in this format: ipv4_address/netmask
TERRAFORM_IP="192.168.0.222/24"
# These devices must be available
# BORG_DNS can be set via system environment : export BORG_DNS=....
if [ "$BORG_DNS" = "" ];then
    BORG_DNS="1.1.1.1"
fi
BORG_ROUTER="192.168.0.254"
BORG_SYSDISK="/dev/vda"
# netmask is 29 for ISCSI target
BORG_ISCSI_T_IP29="172.30.30.1"

# iscsi port bonding
BORG_ISCSI_T2="172.30.30.2"
BORG_ISCSI_T3="172.30.30.3"

### Variables end

### WARNING !!! 
# Limitation: The current country setting is Hungary/Europe. 
# If you want to change this, please modify the preseed template file. 
### WARNING !!!

echo "This is a BORG assimilation :-) script to create a Debian"\
    "installer to an ISCSI target from scratch."

# Replace this password if you really want to do this.
BORG_ISCSI_PWD=assimilated

# Searching terramaster admin system...
if [ -e ../terraform_cli_vm ];then
    BORG_TERRAMASTER_IP=$(grep "TERRAFORM_IP=" ../terraform_cli_vm/generiso.sh | cut -d'"' -f2)
else
# you have to give the ipv4 address of your terramaster admin system in this format
    BORG_TERRAMASTER=192.168.0.1
fi

borg_check_existed_sshkey
borg_ipchecker "$TERRAFORM_IP"

echo "Assimilating the Debian installer to create a Linux system for ISCSI target..."
borg_prepare
sync

borg_late_script "$TMPDIR" "$ORIGINAL_ISO" "../borg_templates/late_script_template.sh" 	\
    "$BORG_TF_CLI_USER" "assimilator" "$BORG_ISCSI_T_IP29" "$BORG_TERRAMASTER_IP"
borg_vminfo "$TMPDIR" "$BORG_TERRAFORMIP" "$BORG_NETMASK" "$BORG_ROUTER" "$BORG_DNS" 	\
    "$BORG_SYSDISK" "$BORG_TF_CLI_USER" "$SCR_ENDFILE"
borg_grub_gen "$TMPDIR"
borg_iso_changer "$TMPDIR" "$NEW_ISO"

sed -e "s@BORG_ISO@$NEW_ISO@g" 		 							\
    -e "s@BORG_USER@$BORG_TF_CLI_USER@g" 							\
    -e "s@terraformclient@iscsitarget@g" 							\
    -e "s@BORG_IP@$BORG_TERRAFORMIP@g" ../borg_templates/kvm_iscsi_template.sh > kvm_terraform.sh

borg_complete
