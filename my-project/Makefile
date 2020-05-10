# Be silent per default, but 'make V=1' will show all compiler calls.
# If you're insane, V=99 will print out all sorts of things.
V?=0
ifeq ($(V),0)
Q       := @
NULL    := 2>/dev/null

# Do not print "Entering directory ...".
MAKEFLAGS += --no-print-directory
endif

OOCD_FILE = /mingw64/share/openocd/scripts/board/stm32f4discovery.cfg
OOCD_INTERFACE = stlink-v2
OOCD_TARGET = stm32f4x
OOCD	?= openocd

WORK_DIR = .
BUILD_DIR = build
PROJECT = f411vet6
LIBS = STM32CubeF4.a

all: lib_dir $(BUILD_DIR)/$(PROJECT).elf secondary-outputs

ifneq ($(MAKECMDGOALS),cleanall)
ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
endif
endif

# All of the sources participating in the build are defined here
include init.mk
include Startup_code.mk
include User_code.mk
include USB_device.mk
include FreeRTOS.mk
include HAL_driver.mk

$(BUILD_DIR)/$(LIBS): $(OBJS)
	@printf "  AR\t$(LIBS)\n"
	$(Q)$(AR) $(ARFLAGS) "$@" $(OBJS)

$(BUILD_DIR)/$(PROJECT).elf: $(BUILD_DIR)/$(LIBS) $(S_OBJS) $(U_OBJS) $(LDSCRIPT)
	$(Q)$(LD) $(LDFLAGS) -o $@ $(S_OBJS) $(U_OBJS) $(BUILD_DIR)/$(LIBS)
	@printf "  LD\t$@\n"
	@echo 'Finished building target: $@'
	@printf '\n'

$(BUILD_DIR)/$(PROJECT).hex: $(BUILD_DIR)/$(PROJECT).elf
	@printf "  HEX\t$<\n"
	$(Q)$(HEX) $< $@
	
$(BUILD_DIR)/$(PROJECT).bin: $(BUILD_DIR)/$(PROJECT).elf
	@printf "  BIN\t$<\n"
	$(Q)$(BIN) $< $@

default.size.stdout: $(EXECUTABLES)
	@printf '\n'
	$(Q)$(SZ)  $(EXECUTABLES)
	@printf '\n'
	@echo 'Finished building: $@'

$(BUILD_DIR)/$(PROJECT).list: $(EXECUTABLES)
	$(Q)$(OBJDUMP) -h -S $(EXECUTABLES) > "$(BUILD_DIR)/$(PROJECT).list"
	@echo 'Finished building: $@'
	@printf '\n'

clean:
	$(Q)$(RM) $(BUILD_DIR)/f411vet6.elf $(BUILD_DIR)/f411vet6.map $(BUILD_DIR)/$(PROJECT).list $(BUILD_DIR)/$(PROJECT).hex \
	$(BUILD_DIR)/$(PROJECT).bin $(BUILD_DIR)/Drivers $(BUILD_DIR)/Middlewares $(BUILD_DIR)/Src $(BUILD_DIR)/Startup
	@printf '\n'
	@echo 'Cleaning...'
	@printf '\n'

cleanall: clean 
	$(Q)$(RM) $(BUILD_DIR)

secondary-outputs: $(SIZE_OUTPUT) $(OBJDUMP_LIST)

flash: $(BUILD_DIR)/$(PROJECT).elf
	@printf "  FLASH\t$<\n"
ifeq (,$(OOCD_FILE))
	$(Q)(echo "halt; program $(BUILD_DIR)/$(PROJECT).elf verify reset" | nc -4 localhost 4444 2>/dev/null) || \
		$(OOCD) -f interface/$(OOCD_INTERFACE).cfg \
		-f target/$(OOCD_TARGET).cfg \
		-c "program $(BUILD_DIR)/$(PROJECT).elf verify reset exit" \
		$(NULL)
else
	$(Q)(echo "halt; program $(BUILD_DIR)/$(PROJECT).elf verify reset" | nc -4 localhost 4444 2>/dev/null) || \
		$(OOCD) -f $(OOCD_FILE) \
		-c "program $(BUILD_DIR)/$(PROJECT).elf verify reset exit" \
		$(NULL)
endif

debug:
	$(Q)xterm -e openocd -f $(OOCD_FILE) -c "init" &
	$(Q)gede

.PHONY: all clean flash
.SECONDARY:
