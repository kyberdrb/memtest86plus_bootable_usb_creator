#!/bin/sh

set -x

DISK_NAME="$1"
DISK_DEVICE="/dev/${DISK_NAME}"

echo "Set the 'boot' and 'lba' flag"
partition_number="$(sudo parted --machine --script "${DISK_DEVICE}" print | tail -n 1 | cut -d':' -f1)"
sudo parted --script "${DISK_DEVICE}" set "${partition_number}" "boot" "on"
sudo parted --script "${DISK_DEVICE}" set "${partition_number}" "lba" "on"

echo "Set the partition name for easier recognition in the file manager and in the terminal"
PARTITION="/dev/$(cat /proc/partitions | grep "${DISK_NAME}" | grep -v "${DISK_NAME}"$ | tr -s ' \t' | rev | cut -d' ' -f1 | rev)"
partition_label="MT86PLUS"
sudo fatlabel "${PARTITION}" "${partition_label}"

# USB installer in Windows names the USB partition as MULTIBOOT
#   although different partition labels, the USB will still boot the same
#sudo fatlabel "${PARTITION}" "MULTIBOOT"

printf "%s\n" "Download lates 'syslinux' package"
sudo pacman --sync --downloadonly --noconfirm --cachedir "/tmp/" syslinux

syslinux_package_in_latest_version="$(find /tmp/ -maxdepth 1 -type f -name "syslinux*" | sort | head --lines=1)"
sudo rm "${syslinux_package_in_latest_version}.sig"

GROUP="$(printf "%s" "${GROUPS}" | cut --delimiter=' ' --fields=1)"
sudo chown ${USER}:${GROUP} "${syslinux_package_in_latest_version}"
7z x -y "${syslinux_package_in_latest_version}" -o/tmp/syslinux_latest

syslinux_inner_package="$(find /tmp/syslinux_latest -type f)"
7z x -y "${syslinux_inner_package}" -o/tmp/syslinux_inner_package

echo "Unmount the single partition that is now on the USB '/dev/${DISK_NAME}'"
PARTITION_NAME=$(cat /proc/partitions | grep "${DISK_NAME}" | rev | cut -d' ' -f1 | rev | grep -v ""${DISK_NAME}"$")
PARTITION_DEVICE="/dev/${PARTITION_NAME}"

udisksctl unmount --block-device "${PARTITION_DEVICE}"
#udisksctl mount --block-device "${PARTITION_DEVICE}"

printf "%s\n" "Installing bootloader with 'syslinux'"
chmod +x "/tmp/syslinux_inner_package/usr/bin/syslinux"

sudo "/tmp/syslinux_inner_package/usr/bin/syslinux" --install "${PARTITION_DEVICE}"

printf "%s\n\n" "SYSLINUX bootloader successfully installed onto "${PARTITION_DEVICE}""

sudo dd bs=440 count=1 conv=notrunc if=/tmp/syslinux_inner_package/usr/lib/syslinux/bios/mbr.bin of=/dev/sdb

printf "%s\n\n" "Bootable MBR has been successfully flashed onto "${DISK_DEVICE}""

sync
sudo sync

echo "Verification"
lsblk -o NAME,FSTYPE,LABEL,UUID "${DISK_DEVICE}"
echo "========================================="
sudo parted --script "${DISK_DEVICE}" print

