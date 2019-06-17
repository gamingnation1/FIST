#!/bin/sh
exec qemu-system-x86_64 -m ${2:-1024} -smp $(nproc) -vga std -full-screen -hda $1