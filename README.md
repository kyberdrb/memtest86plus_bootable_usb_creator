# Memtest86+ bootable USB creator

    - **Making Memtest86+ bootable USB drive in Linux manually**
        1. Open GParted
            1. select USB device from drop down menu in the top right corner - refresh with Ctrl + R if not listed
            1. Device - Create Partition Table - msdos
            1. Partition - New - fat32
            1. Right click on partition - Manage flags - check 'boot' and 'lba'
        1. Open Terminal
            1. Download the `Auto-installer for USB Key (Win 7/8/10)` for the latest version of Memtest86+ from http://www.memtest.org/#downiso
            1. Extract the downloaded `exe` file

                      cd "${HOME}/Downloads/"
                      sudo 7z x "Memtest86+ USB Installer.exe" -oMemtest86Plus_USB_Installer
                      sudo chown --recursive laptop:users Memtest86Plus_USB_Installer/
            
            1. Copy Memtest86+ files to the fat32 partition on the USB drive

                      cd "${HOME}/Downloads/Memtest86Plus_USB_Installer/$PLUGINSDIR/"
                      # Necessary files
                      cp mt86plus /run/media/laptop/D540-1210
                      cp syslinux.cfg /run/media/laptop/D540-1210

                      # Optional files
                      cp Copying /run/media/laptop/D540-1210
                      cp Readme.txt /run/media/laptop/D540-1210

            1. Download and extract `syslinux` package

                      sudo pacman --sync --downloadonly --noconfirm --cachedir "${HOME}/Downloads/" syslinux
                      syslinux_package="$(find "${HOME}/Downloads/" -maxdepth 1 -name "syslinux*" | sort | head --lines=1)"

                      cd "${HOME}/Downloads/"
                      sudo rm "${HOME}/Downloads/${syslinux_package}.sig"
                      sudo 7z x "${HOME}/Downloads/${syslinux_package}"
                      
                      syslinux_inner_package_extraction_dir="$(echo ${syslinux_package%.*} | rev | cut --delimiter='.' --fields=1,2 --complement | rev)"
                      
                      cd "${HOME}/Downloads/"
                      sudo 7z x "${HOME}/Downloads/${syslinux_package%.*} -o${syslinux_inner_package_extraction_dir}
                      sudo chown laptop:users ${syslinux_inner_package_extraction_dir}

            1. Install `syslinux` on the fat32 partition on the USB drive
            
                      sudo "${HOME}/Downloads/${syslinux_inner_package_extraction_dir}/usr/bin/syslinux" --install /dev/sdb1

                where `/dev/sdb1` is the name of the fat32 partition on the USB drive.
  
            1. Flash bootable MBR onto the USB drive

                      sudo dd bs=440 count=1 conv=notrunc if="${HOME}/Downloads/syslinux-6.04.pre2.r11.gbf6db5b4-3-x86_64/usr/lib/syslinux/bios/mbr.bin" of=/dev/sdb

                where `/dev/sdb` is the name of the USB drive.

        1. Unmount the drive

                    sudo umount /dev/sdb1

        1. Test the USB drive by booting from it on the current system, on another computer or in a virtual machine.
