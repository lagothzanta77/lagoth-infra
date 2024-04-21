#!/bin/bash

. /usr/lib/assimilator/borg_end.sh

borg_iscsi_netbonding

borg_ssh
borg_iscsi_pkg

borg_lvm_setup
borg_iscsi_setup

borg_msg
