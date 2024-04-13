#!/bin/bash

. /usr/lib/assimilator/borg_end.sh

borg_ssh

logger "$HOSTNAME: installing terraform and kubectl by this assimilator service"

KUBE_DEB='deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg]'
KUBE_DEB=$KUBE_DEB' https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /'

apt -y install gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg |			\
    gpg --dearmor |							\
    tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
chmod 644 hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | 	\
    tee /etc/apt/sources.list.d/hashicorp.list
mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | 	\
    gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "$KUBE_DEB" | tee /etc/apt/sources.list.d/kubernetes.list
chmod 644 /etc/apt/sources.list.d/kubernetes.list
apt -y update
apt -y install kubectl terraform

borg_msg
