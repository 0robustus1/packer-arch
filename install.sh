#!/usr/bin/env bash

DISK='/dev/sda'
FQDN='vagrant-arch.vagrantup.com'
KEYMAP='us'
LANGUAGE='en_US.UTF-8'
PASSWORD=$(/usr/bin/openssl passwd -crypt "vagrant"})
TIMEZONE='UTC'

ROOT_PARTITION="${DISK}1"

# add_config appends lines to a file which will be run in the final chroot system
add_config() {
  echo "${1}" >> /mnt/usr/local/bin/arch-config.sh
}

echo "==> clearing partition table on ${DISK}"
/usr/bin/sgdisk --zap ${DISK}

echo "==> destroying magic strings and signatures on ${DISK}"
/usr/bin/dd if=/dev/zero of=${DISK} bs=512 count=2048 >/dev/null 2>&1
/usr/bin/wipefs --all ${DISK}

echo "==> creating /root partition on ${DISK}"
/usr/bin/sgdisk --new=1:0:0 ${DISK}

echo "==> setting ${DISK} bootable"
/usr/bin/sgdisk ${DISK} --attributes=1:set:2

echo '==> creating /root filesystem (ext4)'
/usr/bin/mkfs.ext4 -F -m 0 -q -L root ${ROOT_PARTITION}

echo "==> mounting ${ROOT_PARTITION} to /mnt"
/usr/bin/mount -o noatime,errors=remount-ro ${ROOT_PARTITION} /mnt

echo '==> bootstrapping the base installation'
/usr/bin/pacstrap /mnt base base-devel
/usr/bin/arch-chroot /mnt pacman -S --noconfirm syslinux gptfdisk
/usr/bin/arch-chroot /mnt syslinux-install_update -i -a -m
/usr/bin/sed -i 's/sda3/sda1/' /mnt/boot/syslinux/syslinux.cfg

echo '==> generating the filesystem table'
/usr/bin/genfstab -p /mnt >> /mnt/etc/fstab

echo '==> generating the system configuration script'

add_config "echo \"${FQDN}\" > /etc/hostname"
add_config "/usr/bin/ln -s /usr/share/zoneinfo/${TIMEZONE} /etc/localtime"
add_config "echo "KEYMAP=${KEYMAP}" > /etc/vconsole.conf"
add_config "/usr/bin/sed -i \"s/#${LANGUAGE}/${LANGUAGE}/\" /etc/locale.gen"
add_config '/usr/bin/locale-gen'
add_config '/usr/bin/mkinitcpio -p linux'
add_config '/usr/bin/hwclock --systohc --utc'
add_config "/usr/bin/usermod --password ${PASSWORD} root"
add_config "/usr/bin/useradd --password ${PASSWORD} --comment \"Vagrant User\" --create-home --gid users vagrant"
add_config "echo 'vagrant ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/10_vagrant"
add_config '/usr/bin/systemctl start sshdgenkeys.service'
add_config '/usr/bin/systemctl enable sshd.service'
add_config '/usr/bin/systemctl enable dhcpcd@eth0'
add_config '/usr/bin/pacman -Scc --noconfirm'

echo '==> entering chroot and configuring system'
/usr/bin/arch-chroot /mnt /usr/local/bin/arch-config.sh
/usr/bin/arch-chroot /mnt rm /usr/local/bin/arch-config.sh
