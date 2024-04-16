include libs/tinyusb/tools/top.mk
include libs/tinyusb/examples/make.mk

INC += \
	src \
	$(TOP)/hw \

SRC_C += src/usb_descriptors.c

INC += src/nrf52

SRC_C += libs/tinyusb/hw/mcu/nordic/nrfx/drivers/src/nrfx_nvmc.c

CFLAGS += -DNRFX_NVMC_ENABLED=1 \
		  -DNRFX_RNG_ENABLED=1

#ZIG_OBJ += main.o
ZIG_OBJ += zig-out/lib/libcandy-stick.a

include libs/tinyusb/examples/rules.mk
