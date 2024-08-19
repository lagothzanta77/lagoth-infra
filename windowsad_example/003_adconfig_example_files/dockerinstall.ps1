mkdir L:\docker
Start-Sleep 1
New-Item -Path C:\ProgramData\docker -ItemType SymbolicLink -Value L:\docker
Start-Sleep 1
c:\borgfiles\install-docker-ce.ps1
