#!/bin/bash

echo"Starting Arch Config...."
printf"\n"
echo"Making GRUB partition..."
(
echo n
echo p
echo 1
echo  #Default sector
echo +400M #400 MiB for GRUB boot loader
echo w
) | fdisk /dev/sda
printf"\n"
sleep 10
echo"Making root partition..."
(
echo n
echo p
echo 2
echo  #Default sector
echo +10G #10 GiB for root partition
echo w
)| fdisk /dev/sda
printf"\n"
sleep 10
(
echo n
echo p
echo 3
echo  #Default sector
echo +1024M #1 GiB for SWAP
echo w
echo t #Setting type for SWAP partition.
echo 3
echo 82 
)|fdisk /dev/sda
printf"\n"
sleep 10
(
echo n
echo p
echo 4
echo 
echo  #Both default sectors, using remaining disk space for /home.
echo w
)|fdisk /dev/sda
printf"\n"
sleep 10
echo "Disk Partitioning Finished!"
printf"\n"
fdisk -l


