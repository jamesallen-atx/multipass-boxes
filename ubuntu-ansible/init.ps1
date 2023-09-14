multipass.exe launch --name elastic-master --cpus 2 --mem 4G --disk 15G --cloud-init ./cloud-config.yaml 18.04
multipass.exe launch --name elastic-data01 --cpus 2 --mem 4G --disk 15G --cloud-init ./cloud-config.yaml 18.04
multipass.exe launch --name elastic-data02 --cpus 2 --mem 4G --disk 15G --cloud-init ./cloud-config.yaml 18.04
Get-NetIPInterface | where {$_.InterfaceAlias -eq 'vEthernet (WSL)' -or $_.InterfaceAlias -eq 'vEthernet (Default Switch)'} | Set-NetIPInterface -Forwarding Enabled