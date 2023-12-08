#!/usr/bin/env bash

instance_name=$1
if [[ $(uname -r) == *"microsoft"* ]];
then
    multipass.exe launch --name $instance_name --cpus 6 --memory 16G --disk 160G --cloud-init ./cloud-config.yaml 22.04
else
    multipass launch --name $instance_name --cpus 6 --memory 16G --disk 160G --cloud-init ./cloud-config.yaml 22.04
fi