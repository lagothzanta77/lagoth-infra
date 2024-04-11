#!/bin/bash

$SUCCESSED=false
while [ "$SUCCESSED" = "false" ];do
    sleep 3
    apt -y update
    if [ "$?" = "0" ];then SUCCESSED=true;fi
done

logger "installing ssh"
apt -y install ssh

logger "$HOSTNAME: installing terraform and kubectl by this assimilator service"
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
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | \
    tee /etc/apt/sources.list.d/kubernetes.list
chmod 644 /etc/apt/sources.list.d/kubernetes.list
apt -y update
apt -y install kubectl terraform
if [ "$?" = "0" ];then 
    echo "TRUE" > /etc/assimilated.conf
    logger "$HOSTNAME has been assimilated. Resistance is futile!"
fi
