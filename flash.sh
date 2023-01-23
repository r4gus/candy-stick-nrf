#!/bin/sh

# see https://wiki.makerdiary.com/nrf52840-mdk-usb-dongle/programming

nrfutil pkg generate --hw-version 52 --sd-req 0x00 --application-version 1 --application _build/nrf52840_mdk_dongle/candy-stick-nrf.hex app_dfu_package.zip

nrfutil dfu usb-serial -pkg app_dfu_package.zip -p /dev/ttyACM0
