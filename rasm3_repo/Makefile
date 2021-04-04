# Assembler to use.
AS=arm-linux-gnueabihf-as
# Linker to use.
LD=arm-linux-gnueabihf-gcc
# Extra arguments to pass to the assembler.
AS_ARGS = -g
# Extra arguments to pass to the linker.
LD_ARGS = -g

# Directory to store build artefacts in.
BUILD_DIR=./build
# Instruct make that build artefacts exist in $(BUILD_DIR) and should consult there
# before regenerating them.
VPATH = $(BUILD_DIR)

# name of output binary
PROJECT = rasm3

# specify the default goal explicitly to avoid confusion.
.DEFAULT_GOAL: $(PROJECT)

# Specific object files for this project
#
# Sources ending with .asm
SRCS_asm = $(wildcard *.asm)
# sources anding with .S
SRCS_s =  $(wildcard *.S)

# Compute the object file names for the provided sources
# (foo.asm -> foo.o)
OBJS = $(SRCS_asm:.asm=.o) $(SRCS_s:.S=.o)
# as well as their paths in the build directory.
# (foo.asm -> foo.o -> $(BUILD_DIR)/foo.o )
OBJS_paths = $(foreach file, $(OBJS), $(BUILD_DIR)/$(file) )

# Primary build target
$(PROJECT): $(OBJS)
	$(LD) $(LD_ARGS) -o $@ $(OBJS_paths) libbarnett.a


# Ensure the build directory exists.
$(BUILD_DIR):
	-mkdir $(BUILD_DIR)

# Pattern build rule for *.asm -> *.o
%.o: %.asm
	$(AS)  $(AS_ARGS) -o $(BUILD_DIR)/$@ $<

# Pattern build rule for *.S -> *.o
%.o: %.S
	$(AS)  $(AS_ARGS) -o $(BUILD_DIR)/$@ $<

# Clean up build artefacts present in BUILD_DIR
clean:
	rm -f $(wildcard $(BUILD_DIR)/*.o)