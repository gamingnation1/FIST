# Switch multiboot setup

## SD Card setup

#### Pre requisite

- [L4T Ubuntu image](https://gbatemp.net/threads/l4t-ubuntu-a-fully-featured-linux-on-your-switch.537301/)
-  [Android Switchroot - 16GB image](https://forum.xda-developers.com/nintendo-switch/nintendo-switch-news-guides-discussion--development/rom-switchroot-lineageos-15-1-t3951389)
- U-Boot

#### Partition layout table

1. Open **Gparted** & erase all partitions on your SDcard ***make sure to have a backup of your actual SD and a NAND backup***
.
2. Click on **Device menu** -> **Create Partition Table** and choose **GPT** partition type

3. My partition layout is the following :

| Num | PartName | Type  | Size      |
|-----|----------|-------|-----------|
| 1   | HOS      | FAT32 | min. 2GiB |
| 2   | emuMMC   | FAT32 | 29.2GiB   |
| 3   | vendor   | EXT4  | 1.06GiB   |
| 4   | system   | EXT4  | 2.17GiB   |
| 5   | boot     | UF *  | 70.0MiB   |
| 6   | recovery | UF *  | 70.0MiB   |
| 7   | dtb      | UF *  | 30.0MiB   |
| 8   | userdata | EXT4  | min. 16GiB|
| 9   | ubuntu   | EXT4  | min. 7GiB |
| 10  | swap     | SWAP  | 8GB       |

* \* ***UF = Unformatted***
**SWAP is optional**

#### Setting up filesystems

1. Extract `android-16gb.img.gz` & mount the image file : ``` mount /dev/loop0p1 /your/mnt/point ```

2. Copy all files from `/your/mnt/point` to `HOS` partition

3. *Create* `android_boot.scr` using this configuration(Save as android.txt)
	
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

4. *Build* `android_boot.scr` with mkimage (Included with u-boot, needs to be compiled) ``` mkimage -A arm -T script -O linux -d android.txt android_boot.scr ```

5. Replace `switchroot_android/boot.src` with `android_boot.scr` you made and rename it `boot.scr`.

6. Use `dd` to copy android data to partitions. sdcard can be mmcblk0p or sdX<number> It differs depending on the computer.
```
dd if=/dev/loop0p2 of=/dev/<sdcard>3 bs=256M
dd if=/dev/loop0p3 of=/dev/<sdcard>4 bs=256M
dd if=/dev/loop0p4 of=/dev/<sdcard>5 bs=256M
dd if=/dev/loop0p5 of=/dev/<sdcard>6 bs=256M
dd if=/dev/loop0p6 of=/dev/<sdcard>7 bs=256M
```
*\*(Optional) We are skipping userdata folder: If you want to copy userdata from a pre-setup card, then you will need to mount both SD cards userdata partitions, and use ```cp -pr /path/to/existing/userdata /path/to/new/userdata```*

7. Mount ubuntu root partition <image>p2, and `ubuntu` partition from the sdcard <sdcard>p9.

8. Copy data from one to the other using 
``` cp -pr /path/to/linux/root/data /dev/<sdcard>p9 ```

9. /etc/fstab should only contain :

	```
	/dev/mmcblk0p9 / ext4
	/dev/mmcblk0p10 swap swap
	```
	
10. Copy ubuntu boot partition files <image>p1 to `HOS` partition on your SDcard.

11. *Create* `linux_boot.scr` using script below.

	```
	$ echo "load mmc 1:1 0x8d000000 l4t-ubuntu/tegra210-icosa.dtb 
	load mmc 1:1 0x92000000 l4t-ubuntu/initramfs
	setenv bootargs 'root=/dev/mmcblk0p<partition number, here should be 9> rw rootwait relative_sleep_states=1 access=m2 console=tty0 firmware_class.path=/lib/firmware/ fbcon=primary:1'
	usb reset
	booti 0x83000000 0x92000000 0x8d000000" > linux_boot.txt
	```

12. *Build* `linux_boot.scr` with mkimage(Included with u-boot, needs to be compiled) ```mkimage -A arm -T script -O linux -d linux_boot.txt linux_boot.scr ```

13. Replace `l4t-ubuntu/boot.scr` on `HOS` partiton  by `linux_boot.scr`, and rename `linux_boot.src` as `boot.src`

#### Creating hybrid MBR

1. Unmount all partitions that have been mounted on new sdcard (Very Important)

2. Create hybrid MBR: Now that we have the data on the partitions, we need to create a hybrid mbr so we can boot to do this, we need to use gdisk.
gdisk /dev/<path to sdcard> (sdX or mmcblk0)

3. once in gdisk:

    1. Hit r and enter
    
    2. hit h and enter
    
    3. Enter partitions to include in MBR seperated by spaces.
    if you used my partition layout it would be: 1 2
    4. say N to good for grub question.
    
    5. set MBR hex code for both partitions to EE, and dont set bootable flag.
    
    6. once it returns to recovery/transformation command prompt hit o to verify the mbr.
    
    7. If everything looks good, type wq to save and quit.

### Setup EmuNAND

- Launch Hekate
- Make sure to have a backup of your NAND here
- Go to Payloads > Create emuMMC > SD Partition, and enable it

All credits goes to [GavinDarkglider](https://github.com/GavinDarkglider) for the multiboot setup
