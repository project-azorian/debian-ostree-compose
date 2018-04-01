#!/bin/bash
set -eux

STRAPCONF=$1
REF=$2

WORKDIR=/work/debian

rm -rf $WORKDIR
mkdir -p $WORKDIR
cd $WORKDIR

dpkg-deb -x /debs/ostree-boot_2018.2-1~bpo9+1_amd64.deb .
multistrap -d $WORKDIR -f $STRAPCONF

# ----

rm -rf dev/*
cat > password <<EOF
#!/bin/sh
/bin/echo -en "vagrant\nvagrant\n" | passwd root
EOF
chroot . /bin/sh password
rm password

# ----

mv etc usr/etc
mkdir sysroot
ln -s sysroot/ostree ostree

mkdir -p usr/bin usr/lib usr/lib64 usr/sbin
for d in bin lib lib64 sbin; do
    cp -a $d/* usr/$d
    rm -r $d
    ln -s usr/$d $d
done

rm -r var/*
rm -r home opt srv root usr/local mnt media tmp
ln -s var/home home
ln -s var/opt opt
ln -s var/srv srv
ln -s var/roothome root
ln -s var/local usr/local
ln -s var/mnt mnt
ln -s sysroot/tmp tmp
ln -s run/media media

mkdir -p --mode=0755 usr/etc/tmpfiles.d
cat > usr/etc/tmpfiles.d/debian-atomic.conf <<EOF
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

KVER=$(ls usr/lib/modules)
cp boot/vmlinuz-$KVER usr/lib/modules/$KVER/vmlinuz
cp boot/initrd.img-$KVER usr/lib/modules/$KVER/initramfs.img
rm -r boot/* initrd.img initrd.img.old vmlinuz vmlinuz.old

# ----

ostree init --repo=/ostree
ostree commit --repo=/ostree -b $REF $WORKDIR
