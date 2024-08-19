instance-id: ${MYID}
local-hostname: ${MYHOSTNAME}
network:
  version: 2
  ethernets:
    id0:
      match:
        macaddress: ${macaddr}
      set-name: ${ethname}
      addresses:
      - ${ipAddress}
      gateway4: ${gateway}
      nameservers:
        addresses:
        - ${nameserver}
