$borgKey = [byte]1..32
$encrypted = Get-Content c:\borgfiles\borgwin.key | ConvertTo-SecureString -Key $borgKey
