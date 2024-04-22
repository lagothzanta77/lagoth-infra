#cloud-config

hostname: ${HOSTNAME}
manage_etc_hosts: true

packages:
 - webfs
 - mc

write_files:
 - path: /var/www/html/index.html
   encoding: b64
   content: ${HTML_FILE}
   permissions: '0644'
 - path: /var/www/html/borg_image.png
   encoding: b64
   content: ${TOPOLOGY_FILE}
   permissions: '0644'

runcmd:
 - date >/srv/cloudinit.log
 - echo ${HELLO} >>/srv/cloudinit.log
 - echo "Done cloud-init" >>/srv/cloudinit.log
 - nft add rule ip filter INPUT iiftype ether tcp sport 1024-65535 tcp dport 8000 ct state new,related,established counter accept
 - nft add rule ip filter OUTPUT oiftype ether tcp sport 8000 tcp dport 1024-65535 ct state related,established counter accept
 - echo "add rule ip filter OUTPUT oiftype ether tcp sport 8000 tcp dport 1024-65535 ct state related,established counter accept" >>/etc/borg.firewall
 - echo "add rule ip filter INPUT iiftype ether tcp sport 1024-65535 tcp dport 8000 ct state new,related,established counter accept" >>/etc/borg.firewall
