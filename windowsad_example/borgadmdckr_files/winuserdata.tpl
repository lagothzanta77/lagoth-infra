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

$assimilator_content=@"
if ( Test-Path -Path c:\borgfiles\assimilated.conf ) {
    eventcreate /t INFORMATION /id 777 /so Assimilator /l application /d "Assimilation process is already completed."
    exit 0
}

if ( -Not ( Test-Path -Path c:\borgfiles\ad.done ) ) {
    `$userName = "${DCADMIN}@${DCNAME}"
    `$borgKey = [byte]1..32
    `$SecurePassword = Get-Content c:\borgfiles\borgwin.key | ConvertTo-SecureString -Key `$borgKey
    `$credObject = New-Object System.Management.Automation.PSCredential (`$userName, `$SecurePassword)
    New-Item -Path c:\borgfiles\ad.done -ItemType File
    Remove-Item -Path C:\borgfiles\borg* -Force
    Add-Computer -DomainName ${DCNAME} -Server ${NSNAME} -Credential `$credObject -Restart
 }
else {
    try {
        Start-Process msiexec.exe -ArgumentList "/i C:\borgfiles\WindowsAdminCenter.msi /qn /qn /L*v c:\borgfiles\admcenterlog.txt SME_PORT=${ADMPORT} SSL_CERTIFICATE_OPTION=generate" -Wait
        New-Item -Path c:\borgfiles\assimilated.conf -ItemType File
        eventcreate /t INFORMATION /id 777 /so Assimilator /l application /d "Revised assimilation is now completed."
    }
    catch {
        eventcreate /t ERROR /id 779 /so Assimilator /l application /d "Windows Admin Center is failed :-(."
	exit 1
    }

}
"@
Set-Content -Path c:\borgfiles\assimilator.ps1 -Value $assimilator_content

Start-Sleep 2
Set-Service -Name cloudbase-init -StartupType Disabled
Remove-Item -Path C:\borgfiles\cloud* -Force
Remove-Item -Path C:\borgfiles\startassimilator.ps1 -Force

Invoke-WebRequest -UseBasicParsing "https://raw.githubusercontent.com/microsoft/Windows-Containers/Main/helpful_tools/Install-DockerCE/install-docker-ce.ps1" -o c:\borgfiles\install-docker-ce.ps1
Install-WindowsFeature Containers -Restart
