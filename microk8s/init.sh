#!/usr/bin/env bash

if [[ $(uname -r) == *"microsoft"* ]];
then
    multipass.exe launch --name microk8s --cpus 6 --memory 8G --disk 30G --cloud-init ./cloud-config.yaml
else
    multipass launch --name microk8s --cpus 6 --memory 8G --disk 30G --cloud-init ./cloud-config.yaml
fi
