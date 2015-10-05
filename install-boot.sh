#!/bin/bash

#mounting disk as nbd device
set -e
qemu-nbd -d /dev/nbd0
modprobe nbd max_part=63
qemu-nbd -c /dev/nbd0 $1
mount /dev/nbd0p2 /mnt
#grub2 installation
grub2-install --boot-directory=/mnt/boot --modules="ext2 part_msdos" /dev/nbd0p1

#getting initrd and kernel paths

cd /mnt/ostree/*/
PWD_OUT=`pwd`
PWD_LEN=`echo ${#PWD_OUT}`
SHA=""
I=$((PWD_LEN - 1))
J=0

while [ $I -ne 0 ];                                                                              
 do
  J=$((J+1))
  I=$((I-1))
  CHAR=`echo ${PWD_OUT:$I:1}`
    if [ ${CHAR} = "-" ];
  then
         I=$((I+1))
         SHA=`echo ${PWD_OUT:$I:$J}`
        break
     fi
done
KRNL=`basename /mnt/ostree/*/vm*`
INRD=`basename /mnt/ostree/*/ini*`
echo "Found KERNEL and INITRD  !!!"
echo $KRNL
echo $INRD
cd /

#containts of grub.cfg
echo -e "menuentry 'Fedora Atomic 22' {\n
linux /ostree/fedora-atomic-host-$SHA/$KRNL root=UUID=d230f7f0-99d3-4244-8bd9-665428054831 rd.lvm.lv=atomicos/root ostree=/ostree/boot.1/fedora-atomic-host/$SHA/0 \n
initrd /ostree/fedora-atomic-host-$SHA/$INRD
\n}" > /mnt/boot/grub2/grub.cfg

echo "installed grub2 and grub.cfg generated successfully"
#cat /mnt/boot/grub2/grub.cfg
umount /mnt
qemu-nbd -d /dev/nbd0

     

