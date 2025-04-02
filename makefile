# (\ /)
# ( . .)
# c(\")(\")

AS = as
LD = ld
QEMU = qemu-system-x86_64

LOLCATFUN = -a -s 100

# Colors
GREEN = \033[32m
RED = \033[31m
YELLOW = \033[33m
BLUE = \033[34m
MAGENTA = \033[35m
CYAN = \033[36m
WHITE = \033[37m
RESET = \033[0m

# Compiler and linker flags
ASFLAGS = --32
LDFLAGS = -m elf_i386 -Ttext=0x7c00 -nostdlib --oformat=binary
QEMUFLAGS = -fda
QEMUFLAGS_DEBUG = -fda -d int
QEMUFLAGS_DEBUG_VERBOSE = -fda -d int,cpu_reset,in_asm

# Source and object files
BUILD_DIR = build/
SRC_DIR	= src/
BOOT_S = boot.s
BOOT_O = boot.o
TARGET = mbrabbit.bin

# Default target
all: $(BUILD_DIR)$(TARGET)
	@echo -e "Building MBRabbit binary..." | lolcat $(LOLCATFUN)
	@echo -e '(\ /)\n( . .)\nc(")(")\nWelcome to MBRabbit!' | lolcat $(LOLCATFUN)

$(BUILD_DIR)$(TARGET): $(BUILD_DIR)$(BOOT_O)
	@echo -e "Linking MBRabbit..." | lolcat $(LOLCATFUN)
	@$(LD) $(LDFLAGS) $^ -o $@

$(BUILD_DIR)$(BOOT_O): $(SRC_DIR)$(BOOT_S)
	@echo -e "Assembling bootloader..." | lolcat $(LOLCATFUN)
	@$(AS) $(ASFLAGS) $< -o $@

# Emulate the MBR
run: $(BUILD_DIR)$(TARGET)
	@echo -e "Emulating MBRabbit binary..." | lolcat $(LOLCATFUN)
	@$(QEMU) $(QEMUFLAGS) $(BUILD_DIR)$(TARGET)

run-debug: $(BUILD_DIR)$(TARGET)
	@echo -e "Emulating MBRabbit binary in debug mode..." | lolcat $(LOLCATFUN)
	@$(QEMU) $(QEMUFLAGS_DEBUG) $(BUILD_DIR)$(TARGET)

run-debug-verbose: $(BUILD_DIR)$(TARGET)
	@echo -e "Emulating MBRabbit binary in debug mode with verbose output..." | lolcat $(LOLCATFUN)
	@$(QEMU) $(QEMUFLAGS_DEBUG_VERBOSE) $(BUILD_DIR)$(TARGET)

clean:
	@echo -e '(\ /)\n( . .)\nc(")(")' | lolcat $(LOLCATFUN)
	@echo -e "Cleaning up..." | lolcat $(LOLCATFUN)
	@rm -f $(BUILD_DIR)*.o $(BUILD_DIR)*.bin

.PHONY: all run run-debug run-debug-verbose clean
