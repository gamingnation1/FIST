#!/bin/sh
# To use this script simply launch it with the image as option and the amount of ram example :
# ./qemu-launcher.sh your-image.img 4096

exec qemu-system-x86_64 -m ${2:-1024} -smp ${3:-$(nproc)} -vga std -full-screen -hda $1