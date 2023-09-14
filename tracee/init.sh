#!/usr/bin/env bash

if [[ $(uname -r) == *"microsoft"* ]];
then
    multipass.exe launch --name tracee --cpus 2 --mem 4G --disk 15G --cloud-init ./cloud-config.yaml
else
    multipass launch --name tracee --cpus 2 --mem 4G --disk 15G --cloud-init ./cloud-config.yaml
fi