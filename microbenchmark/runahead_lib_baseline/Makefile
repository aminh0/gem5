.SUFFIXES: # This line disables built-in suffix rules

# --- Tool Configuration ---
CLANG = clang
LLC = llc
LLVM_MC = llvm-mc
GCC = riscv64-linux-gnu-gcc

# --- Flags ---
CLANG_FLAGS = -fno-discard-value-names -emit-llvm -target riscv64 -S -O1 -I/usr/riscv64-linux-gnu/include/ -mabi=lp64d
LLC_FLAGS = -mtriple=riscv64 -mattr=+m
LLVM_MC_FLAGS = --triple=riscv64 -mattr=+m -mattr=+d --filetype=obj
GCC_FLAGS = -static

ifeq ($(BASELINE),1)
CLANG_FLAGS += -DBASELINE=1
endif

# --- Find Source Files and Define Targets ---
# Find all .c files in the current directory
SOURCES = $(wildcard *.c)
# Define the target executables by removing the .c extension
TARGETS = $(SOURCES:.c=)

# --- Default Goal: Build All Targets ---
# The first target in the Makefile is the default goal.
# 'all' depends on all the final executable targets.
all: $(TARGETS)

# --- Pattern Rule to create executable from .o ---
# $< is the first prerequisite (the .o file)
# $@ is the target name (the executable)
%: %.o
	$(GCC) $(GCC_FLAGS) $< -o $@
	@echo "===> Linked '$@' successfully."

# --- Pattern Rule to create .o from .s ---
# $< is the first prerequisite (the .s file)
# $@ is the target name (the .o file)
%.o: %.s
	$(LLVM_MC) $(LLVM_MC_FLAGS) $< -o $@
	@echo "===> Assembled '$@' from '$<' successfully."

# --- Pattern Rule to create .s from .ll ---
# $< is the first prerequisite (the .ll file)
# $@ is the target name (the .s file)
%.s: %.ll
	$(LLC) $(LLC_FLAGS) $< -o $@
	@echo "===> Compiled LLVM IR '$<' to assembly '$@' successfully."

# --- Pattern Rule to create .ll from .c ---
# $< is the first prerequisite (the .c file)
# $@ is the target name (the .ll file)
%.ll: %.c
	$(CLANG) $(CLANG_FLAGS) $< -o $@
	@echo "===> Compiled C source '$<' to LLVM IR '$@' successfully."

# --- Clean Target ---
# Removes all generated files (executables, .o, .s, .ll)
clean:
	@echo "Cleaning up generated files..."
	rm -f $(TARGETS) *.o *.s *.ll
	@echo "Cleanup complete."

# --- Phony Targets ---
.SECONDARY: $(%.o)
# Declare targets that are not actual files.
.PHONY: all clean
