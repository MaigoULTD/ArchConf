#!/bin/bash

pacstrap /mnt base base-devel

genfstab /mnt >> /mnt/etc/fstab

arch-chroot /mnt

sed 's:#en_US.UTF-8 UTF-8:en_US.UTF-8 UTF-8:' </etc/locale.gen

locale-gen

echo "LANG=en_US.UTF-8" >> /etc/locale.conf

ln -s /usr/share/zoneinfo/America/New_York /etc/localtime

hwclock --systohc --utc

systemctl enable dhcpcd
systemctl start dhcpcd

echo -e "sandy324\nsandy324"|passwd

#GRUB Install
pacman -S grub os-prober
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

echo "Cleaning Up..."
sleep 30

exit 
umount /mnt
umount /mnt/home
rebootsed 
