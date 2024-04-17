#!/bin/bash

. ../borg_library/borg_preseed_library.sh

ORIGINAL_ISO="../isos/esxi.iso"
NEW_ISO="../isos/borgesxi.iso"
TMPDIR="mytemper"

# This must be in the same subnet as 'TERRAFORM_ESXI_IP'.
ESXI_MGMT_IP=172.30.100.2

### !!! WARNING !!! DON'T USE THIS IP ADDRESS ON YOUR NETWORK!
# THIS IP MUST BE "NON-EXISTENT" ON 'ESXI_MGMT_IP' SUBNET!
ESXI_NONEXISTED_GATEWAY=172.30.100.6
### !!! WARNING !!!
# These must be in the same subnet. (netmask: 29).
ESXI_ISCSI_IP1=172.30.30.4
ESXI_ISCSI_IP2=172.30.30.5
ESXI_ISCSI_IP3=172.30.30.6

# ESXI UPDATE FILE (ZIP) MUST IN `../esxi_update` as: 'esxupd.zip'.

echo "This is a BORG assimilation :-) script to create a VMware ESX(i) installer ISO 
    to an autoconfigured ESX(i) environment from scratch."

borg_precond

borg_esxi_isoprep

genisoimage -relaxed-filenames -V BORG-ESXI-67-ISO -A ESXIMAGE 			\
    -o "$NEW_ISO" -b ISOLINUX.BIN -c BOOT.CAT 					\
    -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot 	\
    -e EFIBOOT.IMG -no-emul-boot "$TMPDIR"

rm -rf $TMPDIR

sed -e "s@BORG_ISO@$NEW_ISO@g" 		 							\
    -e "s@BORG_USER@$BORG_TF_CLI_USER@g" 							\
    -e "s@BORG_IP@$BORG_TERRAFORMIP@g" ../borg_templates/kvm_esxi_template.sh > kvm_terraform.sh
