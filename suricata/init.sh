#!/usr/bin/env bash

if [[ $(uname -r) == *"microsoft"* ]];
then
    multipass.exe launch --name suricata --cpus 6 --memory 8G --disk 160G --cloud-init ./cloud-config.yaml 22.04 --timeout 600
    multipass.exe set client.primary-name=suricata
    multipass.exe mount $HOME suricata:HOME
    multipass.exe mount $HOME suricata:/home/james/HOME
else
    multipass launch --name suricata --cpus 6 --memory 8G --disk 160G --cloud-init ./cloud-config.yaml 22.04 --timeout 600
    multipass set client.primary-name=suricata
    multipass mount $HOME suricata:HOME
    multipass mount $HOME suricata:/home/james/HOME
fi