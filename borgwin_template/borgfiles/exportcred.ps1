$credential = Get-Credential
$Key = [byte]1..32
$credential.Password | ConvertFrom-SecureString -Key $Key | Set-Content c:\borgfiles\borgwin.key
