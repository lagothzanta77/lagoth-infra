#!/bin/bash

# Optional parameter is an ip address of the DNS Server (IPv4)

export BORG_DNS="$1"
cd terraform_cli_vm >/dev/null
bash generiso.sh "$BORG_DNS";sync;sleep 1;bash kvm_terraform.sh
sync;
