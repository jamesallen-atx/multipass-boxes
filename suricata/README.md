# Suricata
# Getting Started

## Prerequisites

- Install [Multipass](https://multipass.run/)

# Using this instance

Use this instance to create a host for testing suricata rules

## Setting up an SSH key for ansible and multipass
From your bash terminal run the following commands
```bash
ssh-keygen -t rsa -b 2048 -C multipass.local -f ~/.ssh/multipass_rsa
eval $(ssh-agent -s)
ssh-add ~/.ssh/multipass_rsa
```
Copy your multipass key to the clipboard and add it to the `cloud-config.yaml` file in this directory under the `ssh_authorized_keys` entry as shown

### Linux
```bash
cat ~/.ssh/multipass_rsa | xclip -selection clipboard
```

### Windows (WSL)
```powershell
cat ~/.ssh/multipass_rsa | clip.exe
```

Open `cloud-config.yaml` and add you ssh key as follows:
```yaml
#cloud-config

users:
- name: multipass
  sudo: ALL=(ALL) NOPASSWD:ALL
  ssh_authorized_keys:
    - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABA... multipass
  
```

> The above procedures can be used with any multipass `cloud-config.yaml` file to add ssh capability for testing.

#### Mac, Linux, or Windows WSL Ubuntu
```bash
./init.sh
```

#### Windows Powershell
Run the following command from an Administrative Powershell Instance.
```powershell
./init.ps1
```

### Setting up IP Forwarding on Hyper-V and WSL V-Switch interfaces to communicate with Hyper-V instances from WSL (Allows kubectl to contact the VM)
```powershell
Get-NetIPInterface | where {$_.InterfaceAlias -eq 'vEthernet (WSL)' -or $_.InterfaceAlias -eq 'vEthernet (Default Switch)'} | Set-NetIPInterface -Forwarding Enabled
```

### Example Ansible inventory for testing
```toml
[linux]
172.29.126.32 ansible_ssh_private_key_file=~/.ssh/multipass_rsa

[linux:vars]
ansible_user=multipass
```
