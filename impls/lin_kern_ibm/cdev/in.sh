#!/bin/bash

sudo insmod fixdev.ko major=255 
ls -l /dev | grep 255 
#dmesg | grep === 
lsmod | grep fix 
cat /proc/devices | grep my_ 

sudo mknod -m0666 /dev/abc c 255 0 

# Usige
cat /dev/abc 

# remove
sudo rm /dev/abc
sudo rmmod fixdev
lsmod | grep fix