# # # #
# CONFIGURATION
# User configurable values live in here, in no specific order
# # #

# name of output binary
PROJECT = lab21

# Assembler to use.
AS=arm-linux-gnueabihf-as

# Path to GCC, used to detect libc and optionally as the linker
GCC = arm-linux-gnueabihf-gcc
# path to G++, used for building tests
CPP = arm-linux-gnueabihf-g++

# Linker to use.
LD=arm-linux-gnueabihf-ld

AR=arm-linux-gnueabihf-ar


# Extra arguments to pass to the assembler.
AS_EXTRA_ARGS = -g

# Extra arguments to pass to the linker
LD_EXTRA_ARGS = -g

AR_EXTRA_ARGS =

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


# specify the default goal explicitly to avoid confusion.
.DEFAULT_GOAL: $(PROJECT)

# Specific object files for this project
#
# Sources ending with .asm
SRCS_asm = $(filter-out %main.asm  ,$(wildcard *.asm))
# sources anding with .S
SRCS_s =  $(wildcard *.S)

# Compute the object file names for the provided sources
# (foo.asm -> foo.o)
OBJS = $(SRCS_asm:.asm=.o) $(SRCS_s:.S=.o)
# as well as their paths in the build directory.
# (foo.asm -> foo.o -> $(BUILD_DIR)/foo.o )
OBJS_paths = $(foreach file, $(OBJS), $(BUILD_DIR)/$(file) )

# Primary build target
$(PROJECT_LIB): $(OBJS)
	$(AR) $(AR_ARGS) -o $(BUILD_DIR)/$(PROJECT_LIB) $(OBJS_paths)

$(PROJECT): $(PROJECT_LIB) main.o
	$(LD) $(LD_ARGS)  $(BUILD_DIR)/main.o -o $@  -L ./build -l$(PROJECT) -L . -lbarnett

test: $(PROJECT_LIB) lab21.cpp
	$(CPP) -g -o lab21  lab21.cpp $(BUILD_DIR)/$(PROJECT_LIB) libbarnett.a
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
