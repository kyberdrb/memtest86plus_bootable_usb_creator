#!/bin/sh

set -x

DISK_NAME="$1"
DISK_DEVICE="/dev/${DISK_NAME}"

SCRIPT_DIR="$(dirname "$(readlink --canonicalize "$0")")"

printf "%s\n" "Downloading latest version of Memtest86+ for USB drives from"
url_to_download_latest_memtest86plus_usb_version="$(${SCRIPT_DIR}/extract_link_for_latest_memtest86plus_for_usb_drives.py)"
printf "%s\n\n" "${url_to_download_latest_memtest86plus_usb_version}"

# example of a download URI: http://www.memtest.org/download/5.31b/memtest86+-5.31b.usb.installer.zip

axel --verbose --num-connections=1 "${url_to_download_latest_memtest86plus_usb_version}" --output="/tmp/memtest86plus_usb_latest.zip"

7z x -y "/tmp/memtest86plus_usb_latest.zip" -o/tmp/memtest86plus_usb_latest/

memtest86plus_exe_path="$(find /tmp/memtest86plus_usb_latest/ -maxdepth 1 -type f -name "*.exe")"

7z x -y "${memtest86plus_exe_path}" -o/tmp/memtest86plus_usb_latest/memtest86plus_extracted_exe

memtest86plus_binary="$(find /tmp/memtest86plus_usb_latest/memtest86plus_extracted_exe -name "mt86plus")"
syslinux_config="$(find /tmp/memtest86plus_usb_latest/memtest86plus_extracted_exe -name "syslinux.cfg")"
copying_file="$(find /tmp/memtest86plus_usb_latest/memtest86plus_extracted_exe -name "Copying*")"
readme_file="$(find /tmp/memtest86plus_usb_latest/memtest86plus_extracted_exe -name "Readme*")"

PARTITION_NAME=$(cat /proc/partitions | grep "${DISK_NAME}" | rev | cut -d' ' -f1 | rev | grep -v ""${DISK_NAME}"$")
PARTITION_DEVICE="/dev/${PARTITION_NAME}"

udisksctl mount --block-device ${PARTITION_DEVICE}
USB_MOUNT_DIR="$(lsblk -oNAME,MOUNTPOINTS "${PARTITION_DEVICE}" | tail --lines=1 | cut --delimiter=' ' --fields=1 --complement)/"

cp "${memtest86plus_binary}" "${USB_MOUNT_DIR}"
cp "${syslinux_config}" "${USB_MOUNT_DIR}"
cp "${copying_file}" "${USB_MOUNT_DIR}"
cp "${readme_file}" "${USB_MOUNT_DIR}"

sync
sudo sync

udisksctl unmount --block-device ${PARTITION_DEVICE}

