# Tracee
> Tracee is a lightweight and easy to use container and system tracing
> tool. It allows you to observe system calls and other system events in
> real time. A unique feature of Tracee is that it will only trace newly
> created processes and containers (that were started after Tracee has
> started), in order to help the user focus on relevant events instead
> of every single thing that happens on the system (which can be
> overwhelming).

# Getting Started

## Prerequisites

- Install [Multipass](https://multipass.run/)

# Why not just install Tracee on your dev system?
- Your system doesn't have all the required software to run Tracee
  (Windows 10 with WSL or WSL2)
- You want to isolate Tracee to a specific VM to reduce the noise from
  other system calls being made after you start Tracee
- You want to make it easier to transfer these tools to other machines

# Using this instance

Install the Tracee instance by opening your shell to this directory and
running the following commands:

#### Mac, Linux, or Windows WSL Ubuntu
```bash
./init.sh
```
#### Windows Powershell
```powershell
./init.ps1
```

The `init.sh` script creates a Ubuntu VM and pre-installs docker and
podman. Additionally, it pulls the latest image for `aquasec/tracee`,
and creates a shortcut for running tracee in the `ubuntu` users
`.bashrc` file.

After the instance starts it's ready for use. You can copy any file you
need from workstation to the tracee instance using the `multipass
transfer` command. See the following example:

```bash
# multipass transfer source destination
multipass transfer ./my_local_directory tracee:/home/ubuntu/
```

## Finding Capabilities
Tracee is invaluable for auditing container Capabilities needed to run a
container. This typically comes into play when a container has been
given privileged access via the docker `--privileged` switch or the
Kubernetes `securityContext` setting. Examples follow below.

##### Docker privileged run command
```bash
docker run --privileged hello-world
```

##### Kubernetes privileged run config
```yaml
apiVersion: apps/v1
kind: Deployment
...
securityContext: 
  privileged: true
...
```

You can view the difference in the capabilities assigned to a container
in privileged by running the `capsh` command inside a running container
without the `--privileged` switch
```bash
$ docker run --rm -it alpine sh -c 'apk add -U libcap; capsh --print | grep Current'

Current: = cap_chown,cap_dac_override,cap_fowner,cap_fsetid,cap_kill,cap_setgid,cap_setuid,cap_setpcap,cap_net_bi
nd_service,cap_net_raw,cap_sys_chroot,cap_mknod,cap_audit_write,cap_setfcap+eip
```

and again with the `--privileged` switch for comparison.
```bash
$ docker run --privileged --rm -it alpine sh -c 'apk add -U libcap; capsh --print | grep Current'

Current: = cap_chown,cap_dac_override,cap_dac_read_search,cap_fowner,cap_fsetid,cap_kill,cap_setgid,cap_setuid,ca
p_setpcap,cap_linux_immutable,cap_net_bind_service,cap_net_broadcast,cap_net_admin,cap_net_raw,cap_ipc_lock,cap_i
pc_owner,cap_sys_module,cap_sys_rawio,cap_sys_chroot,cap_sys_ptrace,cap_sys_pacct,cap_sys_admin,cap_sys_boot,cap_
sys_nice,cap_sys_resource,cap_sys_time,cap_sys_tty_config,cap_mknod,cap_lease,cap_audit_write,cap_audit_control,c
ap_setfcap,cap_mac_override,cap_mac_admin,cap_syslog,cap_wake_alarm,cap_block_suspend,cap_audit_read+eip
```
To find the specific capabilities needed by the container you will start
tracee watching for containers and `cap_capable` events in one terminal,
and use a second terminal to start the container under test.

##### Terminal 1 - Tracee
```bash
tracee --container --events-to-trace "cap_capable" | tee tracee.log
```

##### Terminal 2 - Launch container under test
```bash
docker run --privileged mgoltzsche/podman:latest docker run alpine:latest echo hello from podman
```

This will produce hundreds to thousands of lines in the `tracee.log`
file. We will then filter the log file for the required capabilities and
arguments using `awk` to filter the output file

```bash
cat tracee.log | awk '{print $6, $12}' | sort -u

EVENT ARGS
cap_capable [CAP_CHOWN]
cap_capable [CAP_DAC_OVERRIDE]
cap_capable [CAP_DAC_READ_SEARCH]
cap_capable [CAP_FOWNER]
cap_capable [CAP_FSETID]
cap_capable [CAP_NET_ADMIN]
cap_capable [CAP_SETGID]
cap_capable [CAP_SETPCAP]
cap_capable [CAP_SETUID]
cap_capable [CAP_SYS_ADMIN]
cap_capable [CAP_SYS_PTRACE]
cap_capable [CAP_SYS_RESOURCE]
```
Using this list we can specify which capabilities are allowed for the
container rather than allowing all capabilities by using the
`--privileged` option.

> That default set includes CAP_SYS_ADMIN, and this single capability
> flag grants access to a huge range of privileged activities, including
> things like manipulating namespaces and mounting filesystems.

The example command uses a rootless container running inside a
privileged docker container. We can see the UID 100000 is mapped to the
user of the podman container. This would offer some protection in the
case of a container breakout as the user would not map to a node or
inner container user and thus have limited or no privileges. However, a risk
analysis would need to be completed to determine if the the
functionality was tolerable. It would be better to just not use a privileged container.

```text
TIME(s)        UTS_NAME         MNT_NS       PID_NS       UID    EVENT            COMM             PID    TID    PPID   RET          ARGS
2303           7cf298ac9650     4026532211   4026532214   0      cap_capable      docker           1      1      11175  0           [CAP_SYS_ADMIN]
2303           7cf298ac9650     4026532211   4026532214   0      cap_capable      docker           1      1      11175  0           [CAP_SYS_ADMIN]
2303           7cf298ac9650     4026532211   4026532214   0      cap_capable      docker           1      1      11175  0           [CAP_SYS_ADMIN]
2303           7cf298ac9650     4026532211   4026532214   0      cap_capable      docker           1      1      11175  0           [CAP_SYS_ADMIN]
2303           7cf298ac9650     4026532211   4026532214   100000 cap_capable      docker           1      1      11175  0           [CAP_DAC_OVERRIDE]
2303           7cf298ac9650     4026532211   4026532214   0      cap_capable      docker           1      1      11175  0           [CAP_SYS_ADMIN]
2303           7cf298ac9650     4026532211   4026532214   0      cap_capable      docker           1      1      11175  0           [CAP_SYS_ADMIN]
```

# Resources
1. [Container Security By Liz Rice](https://www.amazon.com/Container-Security-Fundamental-Containerized-Applications-dp-1492056707/dp/1492056707/ref=mt_paperback)
2. [Tracee](https://github.com/aquasecurity/tracee)
3. [Privileged Containers Aren't Containers By Eric Chiang](https://ericchiang.github.io/post/privileged-containers/)
4. [Understanding root inside and outside a container By Scott McCarty](https://www.redhat.com/en/blog/understanding-root-inside-and-outside-container)
