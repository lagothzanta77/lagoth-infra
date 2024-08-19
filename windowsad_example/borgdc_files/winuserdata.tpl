#ps1_sysnative

Disable-NetAdapterBinding -name ${ETHNAME} -ComponentID ms_tcpip6
$netbase = "HKLM:SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces"
$ifaces  = Get-ChildItem $netbase | Select -ExpandProperty PSChildName
foreach ($iface in $ifaces) {
    Set-ItemProperty -Path "$netbase\$iface" -Name "NetbiosOptions" -Value 2
}

$disknr=(Get-Disk | Where-Object IsOffline -eq true).Number
Initialize-Disk -Number $disknr -PartitionStyle GPT
Start-Sleep 2
New-partition -DiskNumber $disknr -DriveLetter L -UseMaximumSize
Start-Sleep 2
Format-Volume -DriveLetter L -FileSystem NTFS -Confirm:$false
Start-Sleep 2
mkdir L:\backups
Start-Sleep 2

$assimilator_content=@"
if ( Test-Path -Path C:\borgfiles\assimilated.conf ) {
    eventcreate /t INFORMATION /id 777 /so Assimilator /l application /d "Assimilation process is already completed."
    exit 0
}

Install-WindowsFeature DHCP -IncludeManagementTools
Start-Sleep 10
Add-DhcpServerv4Scope -Name "borgdcnet" -StartRange ${DHCPSTART} -EndRange ${DHCPEND} -SubnetMask ${NETSUBNET} -Description "Borg DHCP Network"
Set-DhcpServerv4OptionValue -ScopeID (Get-DhcpServerv4Scope).ScopeId.IPAddressToString -DNSServer ${DCIPPURE} -DNSDomain ${DCNAME} -Router ${ROUTER}
Add-DhcpServerSecurityGroup

Start-Sleep 30
while ( -Not (Get-DnsServerZone | Where-Object ZoneName -eq ${DNSPTR} ) ) {
    try {
        Add-DnsServerPrimaryZone -NetworkId ${DCNETWORK} -ReplicationScope Domain
    }
    catch {
        eventcreate /t ERROR /id 779 /so Assimilator /l application /d "PTR DNS Zone is failed..retry later... :-(."
    }
    Start-Sleep 50
}
ipconfig /registerdns

Start-Sleep 60
while ( -Not (Get-DhcpServerInDC | Where-Object IPAddress -eq ${DCIPPURE} ) ) {
    try {
	Add-DhcpServerInDC
    }
    catch {
        eventcreate /t ERROR /id 779 /so Assimilator /l application /d "DHCP is failed..retry later... :-(."
    }
    Start-Sleep 50
}
Restart-Service DHCPServer

New-Item -Path C:\borgfiles\assimilated.conf -ItemType File
eventcreate /t INFORMATION /id 777 /so Assimilator /l application /d "Revised assimilation is now completed."
"@
Set-Content -Path c:\borgfiles\assimilator.ps1 -Value $assimilator_content

Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
$borgKey = [byte]1..32
$SecurePassword = Get-Content c:\borgfiles\borgwin.key | ConvertTo-SecureString -Key $borgKey

Start-Sleep 2
Set-Service -Name cloudbase-init -StartupType Disabled
Remove-Item -Path C:\borgfiles\borg* -Force
Remove-Item -Path C:\borgfiles\cloud* -Force
Remove-Item -Path C:\borgfiles\startassimilator.ps1 -Force

Install-ADDSForest -SkipPreChecks -DomainName ${DCNAME} -SafeModeAdministratorPassword $SecurePassword -Force -DatabasePath "L:\NTDS" -SysvolPath "L:\SYSVOL" -LogPath "L:\DCLOGS"
