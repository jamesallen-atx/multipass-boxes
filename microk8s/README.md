# MicroK8s
# Getting Started

## Prerequisites

- Install [Multipass](https://multipass.run/)

# Using this instance

Install the MicroK8s instance by opening your shell to this directory
and running the following commands:

#### Mac, Linux, or Windows WSL Ubuntu
```bash
./init.sh
```

#### Windows Powershell
Run the following command from an Administrative Powershell Instance.
```powershell
./init.ps1
```

### Setting up IP Forwarding on Hyper-V and WSL V-Switch interfacs to communicate with Hyper-V instances from WSL (Allows kubectl to contact the VM)
```powershell
Get-NetIPInterface | where {$_.InterfaceAlias -eq 'vEthernet (WSL)' -or $_.InterfaceAlias -eq 'vEthernet (Default Switch)'} | Set-NetIPInterface -Forwarding Enabled
```

### Retrieving the Kubernetes Config for kubectl in WSL
```bash
multipass.exe exec microk8s -- microk8s.config > ~/.kube/config-microk8s
```

#### Setting the metallb address for the instance (used for ingress)
```powershell
❯ multipass list
Name                    State             IPv4             Image
microk8s                Running           172.26.148.255   Ubuntu 20.04 LTS
❯ multipass exec microk8s -- microk8s.enable metallb:172.26.148.255-172.26.148.255
```

The `init.sh` script creates a Ubuntu VM and pre-installs MicroK8s with
the following items enabled

  - microk8s.enable dns
  - microk8s.enable fluentd
  - microk8s.enable helm
  - microk8s.enable ingress
  - microk8s.enable linkerd
  - microk8s.enable metallb metallb:172.16.0.2-172.16.0.2
  - microk8s.enable metrics-server
  - microk8s.enable registry
  - microk8s.enable storage
  - microk8s.start



