################################################################
# Makefile for arduino-cli.
# 2024-11-22 Yoshinari Nomura
# https://github.com/yoshinari-nomura/arduino-cli-blink/
################################################################

################################################################
# You should override these settings in project.mk

# PROF_NAME should be a name listed in sketch.yaml
PROF_NAME     := esp32-dev
SERIAL_TOOL   := arduino-cli
PORT          := /dev/ttyUSB0
SPEED         := 115200

# clangd searches build/compile_commands.json,
# I recommend you to set BUILD_DIR to ./build
BUILD_DIR     := ./build

# Comma-separated build options.
# To check available settings:
#   make show-default-board-options
BOARD_OPTIONS := ""

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

ifneq ("$(wildcard project.mk)","")
   include project.mk
endif

################################################################
## Targets

.PHONY: build

build:
	arduino-cli compile \
	--board-options $(BOARD_OPTIONS) \
	--profile $(PROF_NAME) \
	--build-path $(BUILD_DIR) \
	--build-property compiler.cpp.extra_flags=$(EXTRA_FLAGS) \
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
