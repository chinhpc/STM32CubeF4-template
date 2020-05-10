S_SRCS :=
C_SRCS :=
SIZE_OUTPUT :=
OBJDUMP_LIST :=
EXECUTABLES :=
OBJS :=
S_OBJS :=
U_OBJS :=
C_DEPS :=

BINPATH ?=
PREFIX ?= arm-none-eabi-
CC = $(BINPATH)$(PREFIX)gcc
LD = $(BINPATH)$(PREFIX)gcc
AR = $(BINPATH)$(PREFIX)ar
AS = $(BINPATH)$(PREFIX)gcc -x assembler-with-cpp
SZ = $(BINPATH)$(PREFIX)size
OBJCOPY = $(BINPATH)$(PREFIX)objcopy
OBJDUMP = $(BINPATH)$(PREFIX)objdump
HEX = $(OBJCOPY) -O ihex
BIN = $(OBJCOPY) -O binary -S
OOCD ?= openocd
ARFLAGS = rcs

######################################
# building variables
######################################
# debug build?
DEBUG = 1
# optimization
OPT = -Og
#######################################
# CFLAGS
#######################################
# cpu
CPU = -mcpu=cortex-m4

# fpu
FPU = -mfpu=fpv4-sp-d16

# float-abi
FLOAT-ABI = -mfloat-abi=hard

# mcu
MCU = $(CPU) -mthumb $(FPU) $(FLOAT-ABI)


STANDARD_FLAGS ?= -std=gnu11
DEBUG_FLAGS ?= -ggdb3 #-g -gdwarf-2

# compile gcc flags
ASFLAGS = $(MCU) $(OPT) -Wall -fdata-sections -ffunction-sections --specs=nano.specs

CFLAGS = $(MCU) $(STANDARD_FLAGS) $(OPT) -Wall -fdata-sections -ffunction-sections -fstack-usage -MMD -MP --specs=nano.specs

ifeq ($(DEBUG), 1)
CFLAGS += $(DEBUG_FLAGS)
endif

#######################################
# LDFLAGS
#######################################
# link script
LDSCRIPT = STM32F411VETX_FLASH.ld

# libraries
LDLIBS = -lc -lm
LDLIBDIR = -L$(BINPATH)/../arm-none-eabi/lib/thumb/v7+fp/hard
LDFLAGS = $(MCU) -T$(LDSCRIPT) $(LDLIBDIR) -Wl,--start-group $(LDLIBS) -Wl,--end-group --specs=nosys.specs -Wl,-Map=$(BUILD_DIR)/$(PROJECT).map -Wl,--gc-sections -static --specs=nano.specs
#######################################
CubeF4_DIR ?= $(shell realpath ../STM32CubeF4)

lib_dir:
	$(Q)if [ ! "`ls -A $(CubeF4_DIR)`" ] ; then \
		printf "######## ERROR ########\n"; \
		printf "\tSTM32CubeF4 is not initialized.\n"; \
		printf "\tPlease run:\n"; \
		printf "\t$$ git submodule init\n"; \
		printf "\t$$ git submodule update\n"; \
		printf "\tbefore running make.\n"; \
		printf "######## ERROR ########\n"; \
		exit 1; \
	fi
#	$(Q)$(MAKE) -C STM32CubeF4

RM := rm -rf

# Add inputs and outputs from these tool invocations to the build variables
EXECUTABLES += \
$(BUILD_DIR)/$(PROJECT).elf \

SIZE_OUTPUT += \
default.size.stdout \

OBJDUMP_LIST += \
$(BUILD_DIR)/$(PROJECT).list \

SHARED_DIR = Inc \
$(CubeF4_DIR)/Drivers/STM32F4xx_HAL_Driver/Inc \
$(CubeF4_DIR)/Drivers/STM32F4xx_HAL_Driver/Inc/Legacy \
$(CubeF4_DIR)/Middlewares/ST/STM32_USB_Device_Library/Core/Inc \
$(CubeF4_DIR)/Middlewares/ST/STM32_USB_Device_Library/Class/CDC/Inc \
$(CubeF4_DIR)/Middlewares/ST/STM32_USB_Host_Library/Class/CDC/Inc \
$(CubeF4_DIR)/Drivers/CMSIS/Device/ST/STM32F4xx/Include \
$(CubeF4_DIR)/Middlewares/Third_Party/FreeRTOS/Source/include \
$(CubeF4_DIR)/Middlewares/Third_Party/FreeRTOS/Source/portable/GCC/ARM_CM4F \
$(CubeF4_DIR)/Middlewares/Third_Party/FreeRTOS/Source/CMSIS_RTOS_V2 \
$(CubeF4_DIR)/Middlewares/ST/STM32_USB_Host_Library/Core/Inc \
$(CubeF4_DIR)/Drivers/CMSIS/Include \

INCLUDES += $(patsubst %,-I%, . $(SHARED_DIR))
