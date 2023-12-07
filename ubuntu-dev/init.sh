#!/usr/bin/env bash

instance_name=$1
if [[ $(uname -r) == *"microsoft"* ]];
then
    multipass.exe launch --name $instance_name --cpus 6 --mem 16G --disk 160G --cloud-init ./cloud-config.yaml 22.04
    multipass.exe set client.primary-name=$instance_name
    multipass.exe mount $HOME $instance_name:HOME
    multipass.exe mount $HOME $instance_name:/home/james/HOME
else
    multipass launch --name $instance_name --cpus 6 --mem 16G --disk 160G --cloud-init ./cloud-config.yaml 22.04
    multipass set client.primary-name=$instance_name
    multipass mount $HOME $instance_name:HOME
    multipass mount $HOME $instance_name:/home/james/HOME
fi
