#!/bin/bash

. ../borg_library/borg_preseed_library.sh

echo "This Borg Assimilator extension can assimilate Windows Server 2016+!"
echo
echo "!!! This script works without any root permissions (for example su,sudo,mount,etc..) !!!"

BORG_ORIGISO="../isos/w2022.iso"
BORG_ORIGCHECKSUMFILE="w2k22checksum.txt"
BORG_ISONAME="../isos/borg_win2k22.iso"
BORG_TEMPDIR="mytemp"
BORG_PS_FILE="../borg_templates/borg_assimilator.ps1"

# Windows network settings values must be without quotes
BORG_IP=192.168.0.11
BORG_PREFIX=24
BORG_GW=192.168.0.254
if [ "$BORG_DNS" = "" ];then
    BORG_DNS="1.1.1.1"
fi

borg_win_isocheck
borg_win_isoprepare
borg_win_isochanger
borg_win_isomaker

