# Candy Stick

CTAP2 firmware

```
src/
  |- auth_descriptor.zig   (instantiation of the authenticator)
  |- main.zig              (entry point and callbacks)
  |- nrf52/                (nrf52840 specific code) 
  |- tusb_config.h          
  |- usb_descriptors.c
```

> Currently only works with Chrome!

## Build

To build the project you must have installed the [Zig](https://ziglang.org/) (version 0.11.x) compiler on your system.

You also need the `arm-none-eabi` build tools. 

Also make sure that you've `git` installed. Then just run `./build` from the root directory.

### Linux

#### Arch

```
sudo pacman -S arm-none-eabi-gcc arm-none-eabi-newlib
```

> **NOTE**: Without `*-newlib` (Arch) you'll get the `fatal error: stdint.h: No such file or directory
> # include\_next <stdint.h>` error.

#### Debian/ Ubuntu

```
sudo apt install gcc-arm-none-eabi
```

### MAC with Homebrew

```
brew tap ArmMbed/homebrew-formulae
brew upgrade
brew install arm-none-eabi-gcc
```

## Flash

This project targets the nRF52840 MDK USB Dongle, i.e. the Nordic nRF52840 (ARM Cortex-M4F) chip.

We assume that you're using DFU via [Open Bootloader](https://github.com/makerdiary/nrf52840-mdk-usb-dongle/tree/master/firmware/open_bootloader).
You can change from UF2 to Open Bootloader (see [here])https://github.com/makerdiary/nrf52840-mdk-usb-dongle/tree/master/firmware/open_bootloader#change-to-open-bootloader-from-uf2-bootloader)).

> During tests, using UF2 for flashing lead to a corruption of the bootloader. This is why we use Open Bootloader instead.

### Dependencies 

To flash the device you need [nrfutil](https://www.nordicsemi.com/Products/Development-tools/nrf-util).

Download the file and then move it to a location of your likeing, e.g. `sudo cp nrfutil /usr/local/bin`.
After that run the following command:

```
nrfutil install nrf5sdk-tools
nrfutil install device
```

### Flashing

Insert the Dongle into your Pc while pressing the button on the device (LED should start blinking red).

Then just run `./flash.sh <device-path>` (e.g. `./flash.sh /dev/tty.usbmodemE04AC0F44B391`) from within the project folder.

## Tools

To use the tools you need to install `libfido2`.

### Install

#### Linux

##### Arch

```
sudo pacman -S libfido2
```

##### Debian/ Ubuntu

```
$ sudo apt install libfido2-1 libfido2-dev libfido2-doc fido2-tools
```

#### MAC with Homebrew

```
brew install libfido2
```

#### Build from source
```
git clone https://github.com/Yubico/libfido2.git
cd libfido2
cmake -B build
make -C build
sudo make -C build install
```

### Run

The `cred.sh`script can be used to create a new credential and `assert.sh` can be used to verify it.

Both take a number `N` that selects the `/dev/hidrawN` device. If don't use Linux you might need to alter the script slightly.
