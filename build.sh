#!/bin/bash

#./pull-deps.sh
#./checkout.sh

# Compile the Zig part of the app
zig build-obj \
    -target thumb-freestanding-eabihf \
    -mcpu=cortex_m4 \
    -lc \
    --mod zbor::libs/fido2/libs/zbor/src/main.zig \
    --mod fido:zbor:libs/fido2/src/main.zig \
    --deps fido \
    -freference-trace \
    -OReleaseSmall \
    src/main.zig
    #--pkg-begin fido libs/fido2/src/main.zig \
    #    --pkg-begin zbor libs/fido2/libs/zbor/src/main.zig \
    #    --pkg-end \
    #--pkg-end \

# Fetch dependencies
make BOARD=nrf52840_mdk_dongle get-deps

# Build the project
make BOARD=nrf52840_mdk_dongle all
