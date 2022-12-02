#!/bin/sh
set -x
#usage $0  /dev/sdX__usbstick  version__MacFlavor
wget https://github.com/corpnewt/gibMacOS/archive/master.zip
unzip master.zip;cd gibMacOS-master
python gibMacOS.command -v $2
version=$2    #MacFlavor
downloaddir=$(ls macOS\ Downloads/publicrelease/ |grep  $version )
DLdir=$PWD/macOS\ Downloads/publicrelease/"$downloaddir"
device=$1
hfsMountpoint=$PWD/$(mktemp -d temp.XXXXXX)
BaseSystem_fsMountpoint=$PWD/$(mktemp -d temp.XXXXXX)
formatDevice () {
parted -s $1 mklabel gpt
gdisk $1 <<EOF
n
1
2048
+127M
ef00
n
2

-100M
af00
w
Y

EOF

mkfs.vfat  -n EFI "$1"1
mkfs.hfsplus  -v hfs+ "$1"2
}
formatDevice $device
mount -t hfsplus "$device"2 $hfsMountpoint
cd "$DLdir"
dmg2img -v -i BaseSystem.dmg  -p 4 -o BaseSystem_fs.img

mount -t hfsplus -o loop BaseSystem_fs.img $BaseSystem_fsMountpoint
sed -e 's/InstallESDDmg.pkg/InstallESD.dmg/' \
    -e 's/com.apple.pkg.InstallESDDmg/com.apple.dmg.InstallESD/' \
    -e '30,33d' \
      InstallInfo.plist >modInstallInfoplist
cd "$BaseSystem_fsMountpoint";tar -c * | tar -x -C $hfsMountpoint 
macflavor=$(ls $hfsMountpoint | grep Install)

mkdir "$hfsMountpoint"/"$macflavor"/Contents/SharedSupport
InstallDir="$hfsMountpoint"/"$macflavor"/Contents/SharedSupport
cd "$DLdir"
cp BaseSystem.*         "$InstallDir"
cp InstallESDDmg.pkg    "$InstallDir"/InstallESD.dmg
cp modInstallInfoplist  "$InstallDir"/InstallInfo.plist
#cleanup
umount $hfsMountpoint ; rmdir $hfsMountpoint
umount $BaseSystem_fsMountpoint ; rmdir $BaseSystem_fsMountpoint
