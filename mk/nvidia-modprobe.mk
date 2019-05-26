#
# Copyright (c) 2017-2018, NVIDIA CORPORATION. All rights reserved.
#

include $(MAKE_DIR)/common.mk

##### Source definitions #####

VERSION        := 396.51
PREFIX         := nvidia-modprobe-$(VERSION)
URL            := https://github.com/NVIDIA/nvidia-modprobe/archive/$(VERSION).tar.gz

SRCS_DIR       := $(DEPS_DIR)/src/$(PREFIX)
IMPORT_DIR     := $(CURDIR)/import
MODPROBE_UTILS := $(SRCS_DIR)/modprobe-utils

LIB_STATIC     := $(MODPROBE_UTILS)/libnvidia-modprobe-utils.a
LIB_INCS       := $(MODPROBE_UTILS)/nvidia-modprobe-utils.h \
                  $(MODPROBE_UTILS)/pci-enum.h
LIB_SRCS       := $(MODPROBE_UTILS)/nvidia-modprobe-utils.c \
                  $(MODPROBE_UTILS)/pci-sysfs.c

##### Flags definitions #####

ARFLAGS  := -rU
CPPFLAGS := -D_FORTIFY_SOURCE=2 -DNV_LINUX
CFLAGS   := -O2 -g -fdata-sections -ffunction-sections -fstack-protector -fno-strict-aliasing -fPIC

##### Private rules #####

LIB_OBJS := $(LIB_SRCS:.c=.o)

$(IMPORT_DIR)/nvidia-modprobe-$(VERSION).tar.gz:
	echo "downloading: " $(URL)
	mkdir -p $(IMPORT_DIR)
	$(CURL) --progress-bar -fSL $(URL) -o $@

$(SRCS_DIR)/.download_stamp: $(IMPORT_DIR)/nvidia-modprobe-$(VERSION).tar.gz
	echo 'modprobe-utils  SRC_DIR:' $(SRCS_DIR)
	echo $(CURDIR) " " $(MAKE_DIR)
	pwd
	$(MKDIR) -p $(SRCS_DIR)
	cat $(IMPORT_DIR)/nvidia-modprobe-$(VERSION).tar.gz | \
	$(TAR) -C $(SRCS_DIR) --strip-components=1 -xz $(PREFIX)/modprobe-utils
	@touch $@

$(LIB_SRCS): $(SRCS_DIR)/.download_stamp

##### Public rules #####

.PHONY: all install clean

all: $(LIB_STATIC)

$(LIB_STATIC): $(LIB_OBJS)
	$(AR) rs $@ $^

install: all
	$(INSTALL) -d -m 755 $(addprefix $(DESTDIR),$(includedir) $(libdir))
	$(INSTALL) -m 644 $(LIB_INCS) $(DESTDIR)$(includedir)
	$(INSTALL) -m 644 $(LIB_STATIC) $(DESTDIR)$(libdir)

clean:
	$(RM) $(LIB_OBJS) $(LIB_STATIC)
