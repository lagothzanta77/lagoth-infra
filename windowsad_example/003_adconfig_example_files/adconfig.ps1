Set-DhcpServerv4DnsSetting -DynamicUpdates Always -DeleteDnsRROnLeaseExpiry $true
try {
    Enable-ADOptionalFeature -Identity "Recycle Bin Feature" -Scope ForestOrConfigurationSet -Target (Get-ADForest).Name -Confirm:$false
    Start-Sleep 3
    echo "WARNING: AD Recycle Bin is Done!!!"
} 
catch {
    echo "WARNING: AD Recycle Bin is Failed!!!"
}

New-ADOrganizationalUnit -Name Servers
Start-Sleep 1
$list=(Get-ADComputer -Filter * | Where-Object DistinguishedName -Notlike "*Domain Controller*").ObjectGUID
$mytarget="OU=Servers,"+(Get-ADDomainController).DefaultPartition
foreach ( $myitem in $list ) { Move-ADObject -Identity $myitem -Targetpath "$mytarget" }

