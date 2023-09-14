#!/usr/bin/env bash

if [[ $(uname -r) == *"microsoft"* ]];
then
    multipass.exe launch --name ubuntu-dev --cpus 6 --mem 16G --disk 160G --cloud-init ./cloud-config.yaml 20.04
    multipass.exe set client.primary-name=ubuntu-dev
    multipass.exe mount $HOME ubuntu-dev:HOME
    multipass.exe mount $HOME ubuntu-dev:/home/james/HOME
else
    multipass launch --name ubuntu-dev --cpus 6 --mem 16G --disk 160G --cloud-init ./cloud-config.yaml 20.04
    multipass set client.primary-name=ubuntu-dev
    multipass mount $HOME ubuntu-dev:HOME
    multipass mount $HOME ubuntu-dev:/home/james/HOME
fi