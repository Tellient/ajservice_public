# Copyright (c) 2010-2011, AllSeen Alliance. All rights reserved.
#
#    Permission to use, copy, modify, and/or distribute this software for any
#    purpose with or without fee is hereby granted, provided that the above
#    copyright notice and this permission notice appear in all copies.
#
#    THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
#    WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
#    MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
#    ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
#    WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
#    ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
#    OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

# returns current working directory
TOP := $(dir $(CURDIR)/$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST)))

ALLJOYN_DIST := ../..
# for use by AllJoyn developers. Code built from alljoyn_core
#ALLJOYN_DIST := ../../build/linux/x86/debug/dist
#ALLJOYN_DIST := ../../build/linux/x86/release/dist
#ALLJOYN_DIST := ../../build/linux/x86_64/debug/dist
#ALLJOYN_DIST := ../../build/linux/x86_64/release/dist
# for use by AllJoyn developers. Code built from master
#ALLJOYN_DIST := ../../../build/linux/x86/debug/dist
#ALLJOYN_DIST := ../../../build/linux/x86/release/dist
#ALLJOYN_DIST := ../../../build/linux/x86_64/debug/dist
#ALLJOYN_DIST := ../../../build/linux/x86_64/release/dist

OBJ_DIR := obj

BIN_DIR := bin

ALLJOYN_LIB := $(ALLJOYN_DIST)/lib/liballjoyn.a

CXXFLAGS = -Wall -pipe -std=c++98 -fno-rtti -fno-exceptions -Wno-long-long -Wno-deprecated -g -DQCC_OS_LINUX -DQCC_OS_GROUP_POSIX -DQCC_CPU_X86

LIBS = -lstdc++ -lcrypto -lpthread -lrt

.PHONY: default clean

default: all


DOTO:= $(OBJ_DIR)/AnalyticsBusObject.o \
	$(OBJ_DIR)/TellientAnalytics.o \
	$(OBJ_DIR)/TellientSampleHttp.o

all: sample_client sample_service

$(OBJ_DIR)/AnalyticsBusObject.o : AnalyticsBusObject.cc $(ALLJOYN_LIB)
	mkdir -p $(OBJ_DIR)
	$(CXX) -c $(CXXFLAGS) -I$(ALLJOYN_DIST)/inc -o $@ AnalyticsBusObject.cc

$(OBJ_DIR)/TellientAnalytics.o : TellientAnalytics.cc $(ALLJOYN_LIB)
	mkdir -p $(OBJ_DIR)
	$(CXX) -c $(CXXFLAGS) -I$(ALLJOYN_DIST)/inc -o $@ TellientAnalytics.cc

$(OBJ_DIR)/TellientSampleHttp.o : TellientSampleHttp.cc $(ALLJOYN_LIB)
	mkdir -p $(OBJ_DIR)
	$(CXX) -c $(CXXFLAGS) -I$(ALLJOYN_DIST)/inc -o $@ TellientSampleHttp.cc

clean: 
	rm -rf $(OBJ_DIR)
	rm -rf $(BIN_DIR)

test_tado: TellientAnalytics.cc TellientSampleHttp.cc teclient.c test_tado.cc
	cc -g -c -I$(ALLJOYN_DIST)/inc teclient.c
	c++ -o test_tado $(CXXFLAGS) -I$(ALLJOYN_DIST)/inc TellientAnalytics.cc TellientSampleHttp.cc test_tado.cc teclient.o -lcurl $(ALLJOYN_LIB) -lpthread

sample_service: TellientAnalytics.cc TellientSampleHttp.cc teclient.c sample_service.cc AnalyticsBusObject.cc Analytics.h
	cc -g -c -I$(ALLJOYN_DIST)/inc teclient.c
	c++ -o sample_service $(CXXFLAGS) -I$(ALLJOYN_DIST)/inc TellientAnalytics.cc TellientSampleHttp.cc AnalyticsBusObject.cc sample_service.cc teclient.o -lcurl $(ALLJOYN_LIB) -lpthread -lcrypto

sample_client: sample_client.cc  Analytics.h
	cc -g -c -I$(ALLJOYN_DIST)/inc teclient.c
	c++ -o sample_client $(CXXFLAGS) -I$(ALLJOYN_DIST)/inc sample_client.cc teclient.o -lcurl $(ALLJOYN_LIB) -lpthread -lcrypto
