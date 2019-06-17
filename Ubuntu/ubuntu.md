# UbuntuL4T

## Installing new Desktop Environnement

### Installing LXDE

I previousy talk about getting a lighter Desktop Environement for Qemu to eat more RAM
LXDE is the lightest officialy supported DE for ubuntu, as I know.

WARNING !!! : Be aware that this will change your current DE to LXDE so if using GNOME it will be replaced by LXDE.

```
sudo apt install lxde lxde-common
```

LXDE will also mess up some of your configurations such as keyboard layout and orientation

### Changing the orientation

I use *arandr* to bring back the default orientation

```
sudo apt install arandr
```

Open arandr and right-click on the DSI device -> Orientation -> Change it for Left -> Apply the settings

### Changing your keyboard layout

Right-click on the panel -> Add an item to the panel -> Add keyboard layout handler item to panel -> right-click on the country flag and go to keyboard layout settings -> Untick the option for keeping system layout -> Add your desired layout(s) and place it at the level you want with up and down keys.