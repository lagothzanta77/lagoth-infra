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
BORG_ISCSI_NET_HW="52:54:00:12:c4:02"
# netmask is 30 for ISCSI target
BORG_ISCSI_T_IP30="172.30.30.1"
### Variables end

### WARNING !!! 
# Limitation: The current country setting is Hungary/Europe. 
# If you want to change this, please modify the preseed template file. 
### WARNING !!!

echo "This is a BORG assimilation :-) script to create a Debian"\
    "installer to an ISCSI target from scratch."

if [ "$BORG_ISCSI_PWD" = "" ];then
    read -s -p "Please give the iSCSI Password: " BORG_ISCSI_PWD
    echo
    read -s -p "Please give the iSCSI Password again: " BORG_ISCSI_PWD2
    echo
    if [ "$BORG_ISCSI_pwd" != "$BORG_ISCSI_pwd2" ];then
	echo "Passwords don't match."
        exit 1;
    fi
fi

borg_ipchecker "$BORG_ISCSI_T_IP30/30"

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
    "$BORG_TF_CLI_USER" "assimilator" "$BORG_ISCSI_T_IP30" "$BORG_TERRAMASTER_IP"
borg_vminfo "$TMPDIR" "$BORG_TERRAFORMIP" "$BORG_NETMASK" "$BORG_ROUTER" "$BORG_DNS" 	\
    "$BORG_SYSDISK" "$BORG_TF_CLI_USER" "$SCR_ENDFILE"
borg_grub_gen "$TMPDIR"
borg_iso_changer "$TMPDIR" "$NEW_ISO"

sed -e "s@BORG_ISO@$NEW_ISO@g" 		 							\
    -e "s@BORG_USER@$BORG_TF_CLI_USER@g" 							\
    -e "s@BORG_ISCSIMAC@$BORG_ISCSI_NET_HW@g" 							\
    -e "s@terraformclient@iscsitarget@g" 							\
    -e "s@BORG_IP@$BORG_TERRAFORMIP@g" ../borg_templates/kvm_iscsi_template.sh > kvm_terraform.sh

borg_complete
