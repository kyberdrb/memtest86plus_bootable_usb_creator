# Memtest86+ Bootable USB Creator

## Usage

    ./make_memtest86plus_usb.sh sdb

where `sdb` is the USB disk device name from output of the command `lsblk`

## Estimated time to finish tests

- Memtest86+ 2x4GB duration: approx 2 and half hours or more [one pass ~ 45-60 min] (SMT off)
- Memtest86 2x4GB duration: approx 2 and half hours (SMT on)
- Memtest86 2x8GB duration: approx 3 and half hours (SMT on)

## Dependencies

- `python3` - for the extraction script for the URL
    - `python-beautifulsoup` - for parsing the website
    - `python-requests` - for accessing the website
- `parted` - for partitioning the drive
- `dosfstools` - for setting the partition label

## Alternative method - Windows & Linux CO-OP

For the USB drive, create 'msdos' partition table with one 33MiB FAT32 partition

Create the Memtest86Plus USB with the USB installer in Windows

In Linux terminal create an ISO file from the created Memtest USB

        sudo dd if=/dev/sdb1 of=/home/laptop/Downloads/VM_Share-ISOs_and_guides/memtest86+-5.31b.usb.installer.iso

Now you have the Memtest86Plus ISO file at hand. To flash it back, execute

        sudo dd if=/home/laptop/Downloads/VM_Share-ISOs_and_guides/memtest86+-5.31b.usb.installer.iso of=/dev/sdb

Reboot the machine to test it out.

## Sources

- Memtest86+
    - http://www.memtest.org/

- Syslinux
    - https://duckduckgo.com/?q=linux+create+syslinux+usb&ia=web
    - https://wiki.syslinux.org/wiki/index.php?title=Install
    - https://duckduckgo.com/?q=linux+syslinux+install+generic+mbr+boot+code&ia=web
    - https://wiki.syslinux.org/wiki/index.php?title=Mbr
        - **the missing piece of knowledge to understand how the USB makes bootable in MBR environment**

- Python - web scraping
    - https://duckduckgo.com/?q=python+web+scraping&ia=web
    - https://oxylabs.io/blog/python-web-scraping
    - https://archlinux.org/packages/community/any/python-beautifulsoup4/
    - https://duckduckgo.com/?q=soup+select&ia=web
    - https://www.crummy.com/software/BeautifulSoup/bs4/doc/#navigating-using-tag-names
    - https://www.skytowner.com/explore/finding_elements_that_contain_a_specific_text_in_beautiful_soup
    - https://duckduckgo.com/?q=beautifulsoup+extract+all+href+links&ia=web
    - https://www.tutorialspoint.com/how-can-beautifulsoup-be-used-to-extract-href-links-from-a-website
    - https://duckduckgo.com/?q=beuautifulsoup+find+all+links+containing+text&ia=web&iax=qa

- Python - general
    - https://www.pythonpool.com/empty-string-python/
    - https://duckduckgo.com/?q=python+regex+replace+string+pattern&ia=web
    - https://www.educba.com/python-regex-replace/

- vim
    - https://duckduckgo.com/?q=vim+substitute+case+sensitive&ia=web
    - https://stackoverflow.com/questions/2287440/how-to-do-case-insensitive-search-in-vim#2287449

- alternative method
    - https://duckduckgo.com/?q=linux+create+iso+from+usb&ia=web
    - https://www.tecmint.com/create-an-iso-from-a-bootable-usb-in-linux/

- Memtest86
    - https://www.memtest86.com/
    - https://duckduckgo.com/?q=memtest86+bootable+usb&ia=web
    - https://duckduckgo.com/?q=memtest86%2B+arch+linux+systemd-boot&ia=web
    - [Solved] systemd-boot and memtest86+: https://bbs.archlinux.org/viewtopic.php?id=205874
    - https://aur.archlinux.org/packages/memtest86-efi
    - https://github.com/jamesan-unofficial-aur-pkgs/memtest86-efi/blob/master/systemd-boot.conf
    - 

