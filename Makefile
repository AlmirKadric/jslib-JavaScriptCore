##
# JavaScriptCore makefile
# description     : Makefile to build JavaScriptCore static/dynamic library files
# author          : Almir Kadric
# created on      : 2014-10-29
##



##
# Global variables
##

# Set default shell
SHELL = /bin/bash

# Select default platform
# NOTE: Indentation for this section must be spaces and not tabs
ifndef PLATFORM
    ifeq ($(OS),Windows_NT)
        PLATFORM=Windows
    else
        UNAME_S := $(shell uname -s)
        ifeq ($(UNAME_S),Linux)
            PLATFORM=Linux
        else ifeq ($(UNAME_S),Darwin)
            PLATFORM=MacOSX
        else
            $(error Unknown/Unsupported Platform "$(OS)")
        endif
    endif
endif

#
ARCH ?= x64
LTYPE ?= static
BUILDDIR = ./build
DEPSDIR = ./deps

# Paths and URLs for JavaScriptCore
WEBKITVERSION = Safari-600.1.17
WEBKITSVN = http://svn.webkit.org/repository/webkit/tags/$(WEBKITVERSION)
JSCREPO = $(DEPSDIR)/WebKit/Source/JavaScriptCore

# Function to check if a git url has already been cloned, if not it will clone it
define gitClone
	test -d $2 || git clone $1 $2
endef

# Function to check if a git remote already exists in repo, if not add it
define gitAddRemote
	git remote -v | grep -q "^$1" || git remote add $1 $2
endef



##
# Main Targets
##

# List of target which should be run every time without caching
.PHONY: help

define helpMain
  help            Display this help menu
endef
export helpMain

# Default make target
%:: help
Default: help
help:
	@echo ""
	@echo "$$helpMain"
	@echo ""
	@echo "$$helpBuild"
	@echo ""
	@echo "$$helpTest"
	@echo ""
	@echo "$$helpClean"
	@echo ""



##
# Build Targets
##

#
.PHONY: build build-libs copy-headers compress decompress deps deps-repo

define helpBuild
  build           Build JavaScriptCore library files [defaults: ARCH=x64 LTYPE=static]
  build-all       Build JavaScriptCore shared and static library files for all architectures
  compress        Compress builds into *.tar.gz files
  decompress      Decompress builds from *.tar.gz files
endef
export helpBuild

#
build:
	$(MAKE) -f Makefile.$(PLATFORM) build ARCH=$(ARCH) LTYPE=$(LTYPE)

#
build-all:
	$(MAKE) -f Makefile.$(PLATFORM) build-all

#
compress:
	cd $(BUILDDIR) && \
	for platform in $$(ls -d $(PLATFORM).* | grep -v '.tar.gz$$'); do \
		tar czf $${platform}.tar.gz $${platform}; \
	done

#
decompress:
	cd $(BUILDDIR) && \
    for platform in $$(ls -d $(PLATFORM).*.tar.gz); do \
		tar xzf $${platform}; \
    done

#
copy-headers: 									\
	include/JavaScriptCore/JSBase.h				\
	include/JavaScriptCore/JSObjectRef.h		\
	include/JavaScriptCore/JSVirtualMachine.h	\
	include/JavaScriptCore/JSContext.h			\
	include/JavaScriptCore/JSStringRef.h		\
	include/JavaScriptCore/JavaScript.h			\
	include/JavaScriptCore/JSContextRef.h		\
	include/JavaScriptCore/JSStringRefCF.h		\
	include/JavaScriptCore/JavaScriptCore.h		\
	include/JavaScriptCore/JSExport.h			\
	include/JavaScriptCore/JSValue.h			\
	include/JavaScriptCore/WebKitAvailability.h	\
	include/JavaScriptCore/JSManagedValue.h		\
	include/JavaScriptCore/JSValueRef.h

#
include/JavaScriptCore/%.h: $(JSCREPO)/API/%.h
	mkdir -p ./include/JavaScriptCore
	cp $< $@

#
deps-repo:
	cd $(DEPSDIR) && test -d WebKit || svn co $(WEBKITSVN) WebKit --depth empty
	cd $(DEPSDIR) && svn update WebKit --set-depth immediates
	cd $(DEPSDIR) && svn update WebKit/Source --set-depth immediates
	cd $(DEPSDIR) && svn update WebKit/Source/JavaScriptCore --set-depth infinity
	cd $(DEPSDIR) && svn update WebKit/PerformanceTests
	cd $(DEPSDIR) && svn update WebKit/Tools



##
# Test Targets
##

#
.PHONY: test-helloworld

define helpTest
  test-helloworld Compile and run helloworld application
endef
export helpTest

#
test-helloworld:
	$(MAKE) -C ./test/helloworld/shared build PLATFORM=$(PLATFORM)
	$(MAKE) -C ./test/helloworld/static build PLATFORM=$(PLATFORM)
	$(MAKE) -C ./test/helloworld/shared run PLATFORM=$(PLATFORM)
	$(MAKE) -C ./test/helloworld/static run PLATFORM=$(PLATFORM)



##
# Clean Targets
##

#
.PHONY: clean clean-tests clean-deps clean-all

define helpClean
  clean           Clean up build files and headers
  clean-deps      Clean up dependency files
  clean-all       Clean up all files (clean, clean-deps)
endef
export helpClean

#
clean:
	rm -rf $$(ls -d $(BUILDDIR)/$(PLATFORM).* | grep -v '.tar.gz$$')

#
clean-tests:
	$(MAKE) -C ./test/helloworld/shared clean PLATFORM=$(PLATFORM)
	$(MAKE) -C ./test/helloworld/static clean PLATFORM=$(PLATFORM)

#
clean-deps:
	rm -rf $(DEPSDIR)/*

#
clean-all: clean clean-tests clean-deps