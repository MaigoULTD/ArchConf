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
