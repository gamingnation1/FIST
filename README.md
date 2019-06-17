# FIST

## What does FIST means ?

**FIST** means *FrankenIsSwitchTop*, it is a combination of *FrankenSwitch* and *SwicthTop* ( = Switch Laptop )

## What is FIST ?

**FIST** is a set of various tools that provides a laptopish experience for the Nintendo Switch with **UbuntuL4T**.

It is meant to be evolutive and upgradable as time goes on.

## FIST Casing



## FIST Casing V2



## Tutorial for Ubuntu L4T

The following section will talk shortly about **UbuntuL4T**, installing and using various useful softwares and tools for **UbuntuL4T** ( ARM64 )

### Pre Requisite 

- Unpatched Switch with **UbuntuL4T**
- Way to launch the Hekate payload
- A 16G+ micro SD Card ( I recommand using 128G )

### Launching Ubuntu L4T

1. While in **RCM**, launch *Hekate* payload
2. In *Hekate* Go to Launch -> More Configs -> L4T
3. Wait for the **UbuntuL4T** to boot up ( can take up to 3 minutes or more if it is the first boot ) if failing simply shutdown the switch and relaunch the payload
4. If it is the first time booting the switch in UbuntuL4T create the user etc.. otherwise simply connect yourself to your profile
5. Done. Enjoy.

### Installing Dev/SysAdmin tools

Although the Nintendo Switch's architecture is ARM64 you can still find many tools that runs and are compatible with ARM64.

Here is a list of my favorite applications that runs on the switch.

All of the following packages can be installed simply with 

```
sudo apt install *package*
```

#### Terminator

While I do love *tilix*, I was not able to launch it properly on **UbuntuL4T** as it is based on **Ubuntu 18.04** ( hit me up if you found a way to launch it ).
So I'm now using *Terminator* which is really nice and suits my needs ( Terminal multiplexing )

#### NodeJS

As a Web developer I use *NodeJS* a LOT.
Installation can be tedious especially when using *node-gyp* and *node-sass*.

If you encounter problems with *node-sass* do the following :

```
npm rebuild node-sass
```

I also recommand *nvm* for *NodeJS* version management :

```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
```

or simply *N*

```
npm i -g n
```

#### Qemu/KVM/Libvirt/Virt-Manager

Talking about SysAdmin tools virtualisation is a must have.

As *Virtualbox* doesn't have an ARM64 build I'm using *Qemu*, *KVM*, *Libvirt* and *Virt-manager* to manage my Virtual Machines.

I have managed to successfuly installed **Windows XP** *X86* but also **Windows 7** *x86*, I will try to install **Windows 10 Lite** *x86* also ( but as of now I'm having issue installing it)

```
sudo apt install qemu qemu-kvm qemu-arch-extra libvirt-bin virtinst bridge-utils virt-manager
```

and do not forget to add your user to libvirt gorup

```
sudo adduser *username* libvirt && sudo adduser *username* libvirt-qemu
```

I will make a separete tutorail for creating your VM's I highly recommand you to create your VM's on another Machine more ppowerful than the Switch. 

Also don't allocate to much memory as the switch only have 4GB of RAM, or consider using a lighter **Desktop Environnement**.

#### Code-OSS

Which developer environnement would be complete if you don't have a proper code editor.

There are plenty different code editors, I personnaly like *Visual Studio Code* ( Named *code-oss* in ubuntu package system )