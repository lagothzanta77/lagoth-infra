#!/bin/bash

# Optional parameter is an ip address of the DNS Server (IPv4)
export BORG_DNS="$1"
TERRASSH_PORT=33053
ESXISSH_PORT=33054
ESXISSH_WEB=33055

cd terraform_cli_vm >/dev/null
if [ ! -e kvm_terraform.sh ];then
    bash generiso.sh "$BORG_DNS"
fi
sync;sleep 1;bash kvm_terraform.sh
cd - >/dev/null

TERRA_USER=$(grep "^BORG_TF_CLI_USER" terraform_cli_vm/generiso.sh | tr -d '"~' \
    | cut -d"=" -f2)
ISCSI_IP=$(grep "^TERRAFORM_IP" iscsi_target/generiso.sh | tr -d '"~' 	\
    | cut -d"=" -f2 | cut -d"/" -f1)

TERRA_IP=$(grep "^TERRAFORM_IP" terraform_cli_vm/generiso.sh | tr -d '"~' 	\
    | cut -d"=" -f2 | cut -d"/" -f1)

ESXI_IP=$(grep "^ESXI_MGMT_IP" esxi_host/generiso.sh | tr -d '"~' 	\
    | cut -d"=" -f2 | cut -d"/" -f1)

(ssh -o "StrictHostKeyChecking no" -N -i terraform_cli_vm/sshkeys/$TERRA_USER.sshkey	\
     -L $TERRASSH_PORT:$ISCSI_IP:22 -L $ESXISSH_PORT:$ESXI_IP:443 			\
     -L $ESXISSH_WEB:$ESXI_IP:22 $TERRA_USER@$TERRA_IP 2>/dev/null) &

cd iscsi_target >/dev/null
if [ ! -e kvm_terraform.sh ];then
    bash generiso.sh "$BORG_DNS"
fi
sync;sleep 1;bash kvm_terraform.sh
cd - >/dev/null

cd esxi_host >/dev/null
if [ ! -e kvm_terraform.sh ];then
    bash generiso.sh "$BORG_DNS"
fi
sync;sleep 1;bash kvm_terraform.sh
cd - >/dev/null
