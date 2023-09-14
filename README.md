# multipass-cloud-init-files

This repo contains `cloud-init` files for bootstrapping instances of
[Multipass](https://multipass.run/) VMs for running MicroK8s and tooling
for troubleshooting and auditing containers and software.

The following instances are currently supported:
- [Microk8s](https://microk8s.io/) : Used to run a local Kubernetes
  instance for Helm Chart or Operator development.
- [Tracee](https://github.com/aquasecurity/tracee) : Used for auditing
  Linux Kernel Capabilities requested by software or Docker Containers.


