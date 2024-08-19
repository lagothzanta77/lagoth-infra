locals {
    linisoname			= join("",  [ "/vmfs/volumes/","${var.temp_isostore}","/","${var.lin_isofname}" ])
    linvmxname			= join("",  [ "/vmfs/volumes/","${var.temp_datastore}","/","${var.lintemp_guestname}","/","${var.lintemp_guestname}",".vmx" ])

    winisoname			= join("",  [ "/vmfs/volumes/","${var.temp_isostore}","/","${var.win_isofname}" ])
    winvmxname			= join("",  [ "/vmfs/volumes/","${var.temp_datastore}","/","${var.wintemp_guestname}","/","${var.wintemp_guestname}",".vmx" ])

    sshpubkey			= file("inputfiles/sshkey/borgadmin.key.pub")
    keytabfile			= join("",  [ "/home/","${var.linadmin}","/.ssh/dc.keytab" ])
    dcadmin			= join("@", [ "${var.dc_admin}","${var.dc_name}" ])

    dc1winip			= join("/", [ "${var.dc1_winip_pure}","${var.dc_subnet1}" ]) 
    docker1winip		= join("/", [ "${var.windocker1_winip_pure}","${var.dc_subnet1}" ])
    linsrv1ip			= join("/", [ "${var.lin1_ip_pure}","${var.dc_subnet1}" ])

}
