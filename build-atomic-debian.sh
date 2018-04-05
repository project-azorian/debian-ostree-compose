#!/bin/bash
set -eux

STRAPCONF=$1
REF=$2

WORKDIR=/work/debian

rm -rf $WORKDIR
mkdir -p $WORKDIR
cd $WORKDIR

# ----

multistrap -d $WORKDIR -f $STRAPCONF

# ----

mount -o bind /dev dev
mount -o bind /proc proc

cat > setup.sh <<EOF
export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
export LC_ALL=C LANGUAGE=C LANG=C
/var/lib/dpkg/info/dash.preinst install
dpkg --configure -a
EOF
chroot . /bin/bash /setup.sh
rm setup.sh

umount dev
umount proc

# ----

#rm etc/ssh/ssh_host_*_key

# ----

mv var/lib/dpkg usr/lib/dpkg-db

cat > usr/lib/tmpfiles.d/dpkg-db.conf <<EOF
L /var/lib/dpkg - - - - ../../usr/lib/dpkg-db
EOF

# ----

rm -rf dev/*
rm -rf var/*

mv etc usr/etc
mkdir sysroot
ln -s sysroot/ostree ostree

rm -r home opt srv root usr/local mnt media
ln -s var/home home
ln -s var/opt opt
ln -s var/srv srv
ln -s var/roothome root
ln -s var/local usr/local
ln -s var/mnt mnt
ln -s run/media media

# ----

cat > usr/lib/tmpfiles.d/debian-atomic.conf <<EOF
d /var/log/journal 0755 root root -
L /var/home - - - - ../sysroot/home
d /var/opt 0755 root root -
d /var/srv 0755 root root -
d /var/roothome 0700 root root -
d /var/usrlocal 0755 root root -
d /var/usrlocal/bin 0755 root root -
d /var/usrlocal/etc 0755 root root -
d /var/usrlocal/games 0755 root root -
d /var/usrlocal/include 0755 root root -
d /var/usrlocal/lib 0755 root root -
d /var/usrlocal/man 0755 root root -
d /var/usrlocal/sbin 0755 root root -
d /var/usrlocal/share 0755 root root -
d /var/usrlocal/src 0755 root root -
d /var/mnt 0755 root root -
d /run/media 0755 root root -
EOF

# ----

KVER=$(ls usr/lib/modules)
cp boot/vmlinuz-$KVER usr/lib/modules/$KVER/vmlinuz
cp boot/initrd.img-$KVER usr/lib/modules/$KVER/initramfs.img
cp boot/System.map-$KVER usr/lib/modules/$KVER/System.map
cp boot/config-$KVER usr/lib/modules/$KVER/config
rm -r boot/* initrd.img initrd.img.old vmlinuz vmlinuz.old

# ----

ostree init --repo=/ostree
ostree commit --repo=/ostree -b $REF $WORKDIR
