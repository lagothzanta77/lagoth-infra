#!/bin/bash

# This script uses debian 12.4 archive iso.
# You should upgrade your system after install
# You can use other debian ISO but your ISO name must be: "debianinstall.iso"
# You can use symlink, of course.

C_URL="https://gemmei.ftp.acc.umu.se/cdimage/archive/"
C_URL=$C_URL"12.4.0/amd64/iso-cd/debian-12.4.0-amd64-netinst.iso"

DEB124_SHA="64d727dd5785ae5fcfd3ae8ffbede5f40cca96f1580aaa2820e8b99dae989d94"
if ! [ -e ../isos/debianinstall.iso ];then 
    curl "$C_URL" --output ../isos/debianinstall.iso
fi
echo "$DEB124_SHA ../isos/debianinstall.iso" | sha256sum --check
if [ "$?" != "0" ];then echo "The downloaded iso file is corrupt.";exit 1;fi
