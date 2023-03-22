#!/bin/bash

#./pull-deps.sh
#./checkout.sh

# Compile the Zig part of the app
zig build-obj \
    -target thumb-freestanding-eabihf \
    -mcpu=cortex_m4 \
    -lc \
    --mod zbor::libs/zbor/src/main.zig \
    --mod fido:zbor:libs/fido2/lib/main.zig \
    --deps fido \
    -freference-trace \
    -fsingle-threaded \
    -OReleaseSmall \
    src/main.zig

# Fetch dependencies
make BOARD=nrf52840_mdk_dongle get-deps

# Build the project
make BOARD=nrf52840_mdk_dongle all
