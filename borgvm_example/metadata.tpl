network:
    version: 2
    ethernets:
        ens32:
            dhcp4: false
            addresses:
                - ${ipAddress}
            gateway4: ${gateway}
            nameservers:
                addresses:
                    - ${nameserver}
