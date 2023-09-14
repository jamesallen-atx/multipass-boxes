# Postgres 9.6
# Getting Started

## Prerequisites

- Install [Multipass](https://multipass.run/)

# Using this instance

Install the Postgres 9.6 instance by opening your shell to this directory
and running the following commands:

#### Mac, Linux, or Windows WSL Ubuntu
```bash
./init.sh
```
#### Windows Powershell
```powershell
./init.ps1
```

The `init.sh` script creates a Ubuntu VM and pre-installs Postgres 9.6 with
the following:

- 15 GB of disk space
- postgres user with password set to `StrongPassw0rd`
- Open firewall port from any address to port 5432

_Note:_ This is for local development only and is not a valid configuration for a production instance.


