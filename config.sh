#!/bin/bash

echo "Starting Arch Config...."
sleep 3
echo " "
echo "Making GRUB partition..."
sleep 3

(
echo n
echo p
echo 1
echo       #Default sector
echo +400M #400 MiB for GRUB boot loader
echo w
) | fdisk /dev/sda
echo " "
sleep 10

echo "Making root partition..."
sleep 3
(
echo n
echo p
echo 2
echo  #Default sector
echo +10G #10 GiB for root partition
echo w
)| fdisk /dev/sda
echo " "
sleep 10

(
echo n
echo p
echo 3
echo        #Default sector
echo +1024M #1 GiB for SWAP
echo w 
)|fdisk /dev/sda
echo " "
sleep 10

(
echo t
echo 3
echo 82
echo w
)| fdisk /dev/sda
echo ""
sleep 10

(
echo n
echo p
echo 4
echo 
echo    #Both default sectors, using remaining disk space for /home.
echo w
)|fdisk /dev/sda
echo " "
sleep 10

echo "Disk Partitioning Finished!"
echo " "
fdisk -l


