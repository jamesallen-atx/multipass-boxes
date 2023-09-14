#!/usr/bin/env bash

if [[ $(uname -r) == *"microsoft"* ]];
then
    multipass.exe launch --name ubuntu1 --cpus 2 --mem 2G --disk 15G --cloud-init ./cloud-config.yaml
else
    multipass launch --name ubuntu1 --cpus 2 --mem 2G --disk 15G --cloud-init ./cloud-config.yaml
fi