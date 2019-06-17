# Qemu

Various tutorials for using Qemu on the Nintendo Switch

## Creating a Virtual Disk image

Replace *disk-image-name* by the name you wish for your Virtual Disk Image.
Replace XX by the number of GB you wish for your VM.

```
qemu-img create -f qcow2 disk-image-name.img XXG
```

## Installing an OS on a Virtual Disk Image

Replace *disk-image-name* by the previously created *disk-image-name.img*.
Replace /path/to-your/iso-file.iso by the path of your iso image file.

```
qemu-system-x86_64 -hda disk-image-name.img -boot d -cdrom /path/to-your/iso-file.iso -m 1024
```

## Booting a Virtual Disk Image

I like to create a launcher script to boot my VM's.

```
#!/bin/sh
exec qemu-system-x86_64 -hda disk-image-name.img -m 1024
```

## Adding network to your VM

*TBC*

## Adding sound to your VM

*TBC*