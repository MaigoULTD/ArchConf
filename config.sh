#!/bin/bash


echo "Starting Arch Config...."
sleep 3

#### Initial Commands ####
ping -p -c5 www.google.com
if {$OUT -eq 0}
    then continue
    else
        echo "Unable to detect network connection."
        stop
fi

timedatectl set-ntp true
#### End Initial Commands ####
#### Begin Partitioning ####

echo "Making GRUB partition..."
sleep 3

(
echo n
echo p
echo 1
echo 2048 #Default sector
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
echo      #Default sector
echo +10G #10 GiB for root partition
echo w
)| fdisk /dev/sda
echo " "
sleep 10

echo "Assigning Boot flag to root"
sleep 3
(
echo a
echo 2
echo w
)|fdisk /dev/sda
echo " "
sleep 10


echo "Making SWAP Partition"
sleep 3
(
echo n
echo p
echo 3
echo        #Default sector
echo +8G #8 GiB for SWAP (2x RAM)
echo w 
)|fdisk /dev/sda
echo " "
sleep 10

echo "Changing SWAP Partition type to Linux Swap/Solaris (82)"
sleep 3
(
echo t
echo 3
echo 82
echo w
)| fdisk /dev/sda
echo ""
sleep 10

echo "Making /home partition"
sleep 3
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
sleep 60

echo "Mounting Partitions. Abort script if above partitions are incorect."


mkfs.ext4 /dev/sda2
mkfs.ext4 /dev/sda4

mkswap /dev/sda3
swapon /dev/sda3

mount /dev/sda2 /mnt
mkdir /mnt/home
mount /dev/sda4 /mnt/home



#### Begin installation ####
pacstrap /mnt base base-devel

genfstab /mnt >> /mnt/etc/fstab

arch-chroot /mnt

sed 's:#en_US.UTF-8 UTF-8:en_US.UTF-8 UTF-8:' </etc/locale.gen

locale-gen

touch /etc/locale.conf
cat "LANG=en_US.UTF-8" >> /etc/locale.conf

ln -s /usr/share/zoneinfo/America/New_York /etc/localtime

hwclock --systohc --utc

systemctl enable dhcpcd
systemctl start dhcpcd

echo(sandy324)|passwd

#GRUB Install
pacman -S grub os-prober
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

echo "Cleaning Up..."
sleep 120

exit 
umount /mnt
umount /mnt/home
reboot
