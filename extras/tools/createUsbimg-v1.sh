#!/bin/sh
set -x
#usage $0  diskname  size_in_bytes
hfsMountpoint=$(mktemp -d temp.XXXXXX)
BaseSystem_fsMountpoint=$(mktemp -d temp.XXXXXX)
if [ -z $2 ] 
  then
  size=8017412096 
   else size=$2
fi 
end2=$((($size-104857600)/512))
qemu-img create -f raw $1 $size
parted -s $1 mklabel gpt
parted -s $1 mkpart efi fat32 40s 409639s
parted  -s $1 unit s mkpart installer hfs+  409640  $end2

losetup -d /dev/loop* 
loop=$(losetup -f)
losetup -o 20480 -f $1
mkfs.vfat -n EFI $loop
losetup -d /dev/loop*
loop=$(losetup -f)
losetup -o 209735680 -f $1
mkfs.hfsplus -v hfs $loop

mount -t hfsplus $loop $hfsMountpoint
#dmg2img -v -i BaseSystem.dmg  -p 4 -o BaseSystem_fs.img
#mount -t hfsplus -o loop BaseSystem_fs.img $BaseSystem_fsMountpoint
darling-dmg BaseSystem.dmg $BaseSystem_fsMountpoint
cd $BaseSystem_fsMountpoint
sed -e 's/InstallESDDmg.pkg/InstallESD.dmg/' \
    -e 's/com.apple.pkg.InstallESDDmg/com.apple.dmg.InstallESD/' \
    -e '30,33d' \
      InstallInfo.plist >modInstallInfoplist
tar -c * | tar -x -C ../$hfsMountpoint 
cd ../
macflavor=$(ls $hfsMountpoint | grep Install)
cd $hfsMountpoint/"$macflavor"/
mkdir  Contents/SharedSupport
cp ../../BaseSystem.*         Contents/SharedSupport/
cp ../../InstallESDDmg.pkg    Contents/SharedSupport/InstallESD.dmg
cp ../../modInstallInfoplist  Contents/SharedSupport/InstallInfo.plist

cd ../..
umount temp.*
losetup -d /dev/loop*
rm -fr temp.*
