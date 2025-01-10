################################################################
# Makefile for arduino-cli.
# 2024-11-22 Yoshinari Nomura
################################################################

################################################################
# Build settings. You may override in env.mk

# PROF_NAME should be a name listed in sketch.yaml
#
PROF_NAME := m5stamp-c3

# In case WSL2, uploader is arduino-cli.exe and serial is COMx.
#
ifneq (,$(findstring microsoft,$(shell uname -r)))
SERIAL_TOOL := arduino-cli.exe
PORT        := COM1
else
SERIAL_TOOL := arduino-cli
PORT        := /dev/ttyACM1
endif

# clangd searches build/compile_commands.json,
# I recommend you to set BUILD_DIR to ./build
#
BUILD_DIR := ./build

# Serial speed on monitor.
#
SPEED     := 115200

# Comma-separated build options.
# To check available settings:
#   make show-default-board-options
#
BOARD_OPTIONS="CDCOnBoot=default"

################################################################
# Utilities

# Extract FQBN from profile data
#
fqbn = $(shell arduino-cli compile \
               --show-properties \
               --profile $(PROF_NAME) \
               --format text | \
               sed -n 's/^build.fqbn=\(.*\)/\1/p')

################################################################
# Override default settings

ifneq ("$(wildcard env.mk)","")
   include env.mk
endif

################################################################
## Targets

.PHONY: build

build:
	arduino-cli compile \
	--board-options $(BOARD_OPTIONS) \
	--profile $(PROF_NAME) \
	--build-path $(BUILD_DIR) \
	--log

upload:
	$(SERIAL_TOOL) upload \
	--profile $(PROF_NAME) \
	--input-dir $(BUILD_DIR) \
	--port $(PORT)

monitor:
	$(SERIAL_TOOL) monitor \
	--port $(PORT) \
	--config baudrate=$(SPEED)

clean:
	rm -rf $(BUILD_DIR)

show-default-board-options:
	@arduino-cli board details \
	--fqbn $(call fqbn)

show-properties:
	@arduino-cli compile \
	--show-properties \
	--profile $(PROF_NAME)

setup-arduino-cli:
	curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | BINDIR=$(PWD) sh
	@echo "Move ./arduino-cli to your bin directory."
	@echo "And do arduino-cli config init --log"
