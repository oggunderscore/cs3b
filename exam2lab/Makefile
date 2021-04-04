# Unknown's asm makefile.
# This makefile will detect all *.asm and *.S asm sources and build corresponding .o's
# in the BUILD_DIR.

# PHASE 1: all .asm and .S sources EXCEPT main.asm will be assembled into object .o files.
#   This is done to produce a $(PROJECT).a library artefact in the BUILD_DIR.
#   Building a .a library object is done to facilitate testing using alternative
#   entry-points.
# PHASE 2: Once $(PROJECT).a is generated, `main.asm` will be compiled to object code,
#   and the executable $(PROJECT) will be linked in the CWD
# NOTE:
# This makefile works both in cross-compile situations and native builds
# It has been tested tested against Ubuntu 18.04's armhf crossbuild and on a RPi 4b.
#
# If your system uses a different cross-compiler, you will need to adjust AS, GCC, LD

# # # #
# CONFIGURATION
# User configurable values live in here, in no specific order
# # #

# name of output binary
PROJECT = exam2

# Specify who owns main,
# valid options are:
# `cpp` : main.cpp
# `asm`: main.asm
WHICH_MAIN = "asm"

# Assembler to use.
AS=arm-linux-gnueabihf-as

# Which gcc to use, primarily for libc detection
GCC = arm-linux-gnueabihf-gcc
# path to cpp compiler
CPP = arm-linux-gnueabihf-g++

# Linker to use.
LD=arm-linux-gnueabihf-ld

AR=arm-linux-gnueabihf-ar


# Extra arguments to pass to the assembler.
AS_EXTRA_ARGS = -g

# Extra arguments to pass to the linker
LD_EXTRA_ARGS = -g

AR_EXTRA_ARGS =

CPP_EXTRA_ARGS = -g

# Directory to store build artefacts in.
BUILD_DIR=./build

# # END CONFIGUREABLES

# #
# LIBC path computation, since this varies based on compiler setup.
#
PATH_LIBC = $(shell $(GCC) --print-file-name=libc.so )
PATH_LIBC_LD = $(shell $(GCC) --print-file-name=ld-linux-armhf.so.3)
LD_LIBC_ARGS = $(PATH_LIBC) -dynamic-linker $(PATH_LIBC_LD)

# name of project library, following standard naming convention.
PROJECT_LIB = lib$(PROJECT).a

# Compute final additional arguments to pass to the linker
LD_ARGS = $(LD_LIBC_ARGS) $(LD_EXTRA_ARGS)

# Compute final additional arguments to pass to the assembler
AS_ARGS = $(AS_EXTRA_ARGS)

AR_ARGS = $(AR_EXTRA_ARGS) rvs
# Instruct make that build artefacts exist in $(BUILD_DIR) and should consult there
# before regenerating them.
VPATH = $(BUILD_DIR)

CPP_ARGS = $(CPP_EXTRA_ARGS)


# specify the default goal explicitly to avoid confusion.
.DEFAULT_GOAL: $(PROJECT)



# Specific object files for this project
#
# Sources ending with .asm
SRCS_asm = $(filter-out %main.asm  ,$(wildcard *.asm))
# sources ending with .S
SRCS_S  =  $(wildcard *.S)
# sources ending with .s
SRCS_s = $(wildcard *.s)
# Compute the object file names for the provided sources
# (foo.asm -> foo.o)
OBJS = $(SRCS_asm:.asm=.o) $(SRCS_s:.s=.o) $(SRCS_S:.S=.o)
# as well as their paths in the build directory.
# (foo.asm -> foo.o -> $(BUILD_DIR)/foo.o )
OBJS_paths = $(foreach file, $(OBJS), $(BUILD_DIR)/$(file) )

# Primary build target
$(PROJECT_LIB): $(OBJS)
	$(AR) $(AR_ARGS) -o $(BUILD_DIR)/$(PROJECT_LIB) $(OBJS_paths)

ifeq ($(WHICH_MAIN), "asm")
$(PROJECT): $(PROJECT_LIB) main.o
	$(LD) $(LD_ARGS)  $(BUILD_DIR)/main.o -o $@  -L ./build -l$(PROJECT) -L . -lbarnett
else
$(PROJECT): $(PROJECT_LIB) main.cpp
	$(CPP) $(CPP_ARGS)  -o $@ main.cpp -I=./include ./build/$(PROJECT_LIB) ./libbarnett.a
endif
test: $(PROJECT_LIB) test.cpp include/linked_list.h
	$(CPP) -g -o test  test.cpp -I ./include $(BUILD_DIR)/$(PROJECT_LIB) libbarnett.a
# Pattern build rule for *.asm -> *.o
%.o: %.asm
	$(AS)  $(AS_ARGS) -o $(BUILD_DIR)/$@ $<

# Pattern build rule for *.S -> *.o
%.o: %.S
	$(AS)  $(AS_ARGS) -o $(BUILD_DIR)/$@ $<

# Pattern build rule for *.s -> *.o
%.o: %.s
	$(AS)  $(AS_ARGS) -o $(BUILD_DIR)/$@ $<

# Clean up build artefacts present in BUILD_DIR
clean:
	rm -f $(wildcard $(BUILD_DIR)/*.o) $(wildcard $(BUILD_DIR)/*.a)