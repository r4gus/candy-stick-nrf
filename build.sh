#!/bin/bash

#./pull-deps.sh
#./checkout.sh

# Compile the Zig part of the app
#zig12 build-obj \
#    -target thumb-freestanding-eabihf \
#    -mcpu=cortex_m4 \
#    -lc \
#    -freference-trace \
#    -fsingle-threaded \
#    -OReleaseSmall \
#    src/main.zig
zig build -Dtarget=thumb-freestanding-eabihf -Dcpu=cortex_m4 -Doptimize=ReleaseSmall

# Fetch dependencies
make BOARD=nrf52840_mdk_dongle get-deps

# Build the project
make BOARD=nrf52840_mdk_dongle all
