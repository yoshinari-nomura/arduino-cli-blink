################################################################
# project.mk example for arduino-cli.
# 2024-11-22 Yoshinari Nomura
# https://github.com/yoshinari-nomura/arduino-cli-blink/
#
# This file is just an example, so it may be a bit overkill.
################################################################

################
# select PROF_NAME listed in sketch.yaml

PROF_NAME     := esp32-dev
# PROF_NAME     := m5stamp-c3u

################
# example for each PROF_NAME

ifeq ($(PROF_NAME),esp32-dev)
  # ESP32 DevKit:
  PORT          := /dev/ttyUSB0
  SPEED         := 115200

else ifeq ($(PROF_NAME),m5stamp-c3)
  # M5Stamp C3
  PORT          := /dev/ttyUSB0
  EXTRA_FLAGS   := -DUSE_FAST_LED

else ifeq ($(PROF_NAME),m5stamp-c3u)
  # M5Stamp C3U
  PORT          := /dev/ttyACM0
  EXTRA_FLAGS   := -DUSE_FAST_LED

  # Comma-separated build options.
  # To check available settings:
  #   make show-default-board-options
  #
  # CDCOnBoot should be
  #   disabled (default) on M5Stamp Stamp-C3
  #   enabled on M5Stamp Stamp-C3U
  BOARD_OPTIONS := "CDCOnBoot=default"
endif
