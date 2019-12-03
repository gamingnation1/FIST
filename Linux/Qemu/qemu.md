# Qemu

Various tutorials for using Qemu on the Nintendo Switch.

Anytime you see *disk-image-name* replace *disk-image-name* by the name you wish for your Virtual Disk Image.

## Creating a Virtual Disk image

Replace XX by the number of GB you wish for your VM.

```
qemu-img create -f qcow2 disk-image-name.img XXG
```

## Installing an OS on a Virtual Disk Image

I highly recommand installing the OS with a more powerfull computer than the Switch and then moving the image back to the switch.

Replace /path/to-your/iso-file.iso by the path of your iso image file.

```
qemu-system-x86_64 -m 1024 -hda disk-image-name.img -boot d -cdrom /path/to-your/iso-file.iso 
```

## Booting a Virtual Disk Image

I like to create a launcher script to boot my VM's.

```
#!/bin/sh
exec qemu-system-x86_64 -m 1024 -hda disk-image-name.img
```

## Adding network passthrough to your VM

*TBC*

## Adding sound to your VM

*TBC*

## Using all avalaible CPU cores

Add *-smp $(nproc)* to the script to use all available cores otherwise change *$(nproc)* to the number of cores you want to use

```
#!/bin/sh
exec qemu-system-x86_64 -m 1024 -smp $(nproc) -hda disk-image-name.img 
```

## Make qemu VM use fullscreen

Adds -full-screen option to the script

```
#!/bin/sh
exec qemu-system-x86_64 -m 1024 -vga std -full-screen -hda disk-image-name.img
```

## Resizing the VM image disk

Use the following command and replace X by the number of GB you want to add.

```
qemu-img resize disk-image-name.img +XGB
```

Then in the guest OS resize the partition to fill the empty sapce as needed.

## Finished script

Finished script looks like this :

```
#!/bin/sh
exec qemu-system-x86_64 -m 1024 -smp $(nproc) -vga std -full-screen -hda disk-image-name.img
```

You can also find a better script named qemu-launcher.sh here you can input your own image and RAM and just launch it.

## Usage of qemu-launcher.sh

To use this script simply launch it with the image as option, the amount of RAM, and the number of CPU cores ( default is all CPU cores available ).

Example :

```
./qemu-launcher.sh your-image.img 4096
```

## Script Launcher

You can use this nice scipt launcher to manage your VM scripts [WoM](https://github.com/BNNJ/WoM)

## Thanking

[BNNJ](https://github.com/BNNJ) For his Script Launcher/VM manager binary and releasing his sources.