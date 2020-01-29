# FIST

## What does FIST means ?

**FIST** is an anagram for ***FrankenIsSwitchTop*** which is a mix between ***FrankenSwitch*** and ***SwicthTop*** *for Switch Laptop*

## What is FIST ?

**FIST** is a set of various tools that provides a laptopish experience for the Nintendo Switch with **FedoraL4T**, **UbuntuL4T**, **Android switchroot**, **EmuNAND** and **LakkaL4T** on 1 SD card.

## SD Card setup

- 128GB Micro SD card is ***highly recommanded***
- Unpatched Switch
- RCM tools

### Partitionning the SD card

The most tricky part is to have a correct layout with a **hybrid MBR** boot sector.

#### Pre requisite

- [LakkaL4T](https://lakka-switch.github.io/documentation/archives.html)
- [L4T Ubuntu image](https://gbatemp.net/threads/l4t-ubuntu-a-fully-featured-linux-on-your-switch.537301/)
-  [Android Switchroot - 16GB image](https://forum.xda-developers.com/nintendo-switch/nintendo-switch-news-guides-discussion--development/rom-switchroot-lineageos-15-1-t3951389)
- L4T Fedora image ***available soon***
- U-Boot
#### Partition layout table

1. Open **Gparted** & Erase all partitions from SDcard ***make sure to have a backup of your actual SD and a NAND backup***

2. Click on **Device menu** & then Click on **Create Partition Table** & finally Choose **GPT** partition type

3. Create Partitions according to this table :

| Num | PartName | Type  | Size    |
|-----|----------|-------|---------|
| 1   | hos_data | FAT32 | 112.8GiB|
| 2   | emunand  | FAT32 | 29.2GiB |
| 3   | vendor   | EXT4  | 1.06GiB |
| 4   | system   | EXT4  | 2.17GiB |
| 5   | boot     | UF *  | 70.0MiB |
| 6   | recovery | UF *  | 70.0MiB |
| 7   | dtb      | UF *  | 30.0MiB |
| 8   | userdata | EXT4  | 100GiB  |
| 9   | fedora   | EXT4  | 30GiB   |
| 10  | ubuntu   | EXT4  | 30GiB   |
| 11  | swap     | SWAP  | 8GB     |
| 12  | shared   | NTFS  | ALL     |

* \* ***UF = Unformatted***

##### Nota Bene:

- SWAP : 8GB, optional) Partition Name:linux_swap type: linux_swap
- NTFS : any space, optional shared between lakka, android, and linux

#### Setting up filesystem

1. Extract **LakkaL4T** to /dev/\<partition>1.

2. Extract android-16gb.img.gz & mount android.img using : ``` mount /dev/loop0p1 /mnt ```

3. Copy android partition 1 to **hos_data** partition

4. *Create* **android** boot.scr using this configuration(Save as android.txt)
	
	``` console 
	$ echo "setenv bootargs 'log_buf_len=4M access=m2 androidboot.bootreason=recovery androidboot.hardware=icosa androidboot.console=ttyGS0 console=tty0 androidboot.selinux=permissive fbcon=primary:0 androidboot.serialno='${serialno}
	if gpio input 190; then
	part start mmc 1 5 aistart
	part size mmc 1 5 aisize
	else
	part start mmc 1 6 aistart
	part size mmc 1 6 aisize
	fi
	mmc read 0x98000000 ${aistart} ${aisize}
	boota 0x98000000" > android.txt
	```

5. *Build* **android** boot.scr with mkimage (Included with u-boot, needs to be compiled) ``` mkimage -A arm -T script -O linux -d android.txt android_boot.scr ```
6. Replace boot.scr in switchroot android folder with the copy you just created make sure to rename it to boot.scr.

7. Use dd to copy android data to partitions. sdcard can be mmcblk0p or sdX<number> It differs depending on the computer.
```
dd if=/dev/loop0p2 of=/dev/<sdcard>3 bs=256M
dd if=/dev/loop0p3 of=/dev/<sdcard>4 bs=256M
dd if=/dev/loop0p4 of=/dev/<sdcard>5 bs=256M
dd if=/dev/loop0p5 of=/dev/<sdcard>6 bs=256M
dd if=/dev/loop0p6 of=/dev/<sdcard>7 bs=256M
```
*\*(Optional) We are skipping userdata folder: If you want to copy userdata from a pre-setup card, then you will need to mount both SD cards userdata partitions, and use ```cp -pr /path/to/existing/userdata /path/to/new/userdata```*

8. Mount linux root from image and linux root partition on new sdcard.

9. Copy data from one to the other using 
``` cp -pr /path/to/linux/root/data /path/to/new/linux/root ```

10. edit /etc/fstab from :


	``` console
	/dev/root / ext4
	```
to :

	```console
	/dev/mmcblk0p<# of linux root> / ext4
	```
	
11. Copy bootloader linux image to **hos_data** partition on new SDcard.

12. *Create* **Linux** boot.scr using script below.

	```
	$ echo "load mmc 1:1 0x8d000000 l4t-ubuntu/tegra210-icosa.dtb 
	load mmc 1:1 0x92000000 l4t-ubuntu/initramfs
	setenv bootargs 'root=/dev/mmcblk0p<partition number> rw rootwait relative_sleep_states=1 access=m2 console=tty0 firmware_class.path=/lib/firmware/ fbcon=primary:1'
	usb reset
	booti 0x83000000 0x92000000 0x8d000000" > linux_boot.txt
	```

13. *Build* **Linux** boot.scr with mkimage(Included with u-boot, needs to be compiled) ```mkimage -A arm -T script -O linux -d linux_boot.txt linux_boot.scr ```

14. Replace hos_data/l4t-ubuntu/boot.scr with linux_boot.scr

15. Rename linux_boot.scr to boot.scr

#### Creating hybrid MBR

1. Unmount all partitions that have been mounted on new sdcard (Very Important)

2. Create hybrid MBR: Now that we have the data on the partitions, we need to create a hybrid mbr so we can boot to do this, we need to use gdisk.
gdisk /dev/<path to sdcard> sdX or mmcblk0

3. once in gdisk:

    1. Hit r and enter
    
    2. hit h and enter
    
    3. Enter partitions to include in MBR seperated by spaces.
    if you used my partition layout it would be: 1 2
    4. say N to good for grub question.
    
    5. set MBR hex code for both partitions to EE, and dont set bootable flag.
    
    6. once it returns to recovery/transformation command prompt hit o to verify the mbr.
    
    7. If everything looks good, type wq to save and quit.

#### EmuNAND

- Launch Hekate
- Make sure to have a backup of your NAND here
- Go to Payloads > Create emuMMC > SD Partition, and enable it

All credits goes to [GavinDarkglider](https://github.com/GavinDarkglider) for the multiboot setup
