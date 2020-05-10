# /*
# * Copyright (C) 2019 ChinhPC <chinhphancong@outlook.com>
# * 
# * Author: ChinhPC
# *
# * This file is free software: you can redistribute it and/or modify it
# * under the terms of the GNU General Public License as published by the
# * Free Software Foundation, either version 3 of the License, or
# * (at your option) any later version.
# * 
# * This file is distributed in the hope that it will be useful, but
# * WITHOUT ANY WARRANTY; without even the implied warranty of
# * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# * See the GNU General Public License for more details.
# * 
# * You should have received a copy of the GNU General Public License along
# * with this program.  If not, see <http://www.gnu.org/licenses/>.
# */

_OBJ = \
stm32f4xx_hal_crc.o \
stm32f4xx_hal_i2c.o \
stm32f4xx_hal_i2c_ex.o \
stm32f4xx_hal_i2s.o \
stm32f4xx_hal_i2s_ex.o \
stm32f4xx_hal_rtc.o \
stm32f4xx_hal_rtc_ex.o \
stm32f4xx_hal_spi.o \
stm32f4xx_hal_tim.o \
stm32f4xx_hal_tim_ex.o \
stm32f4xx_hal_uart.o \
stm32f4xx_ll_usb.o \
stm32f4xx_hal_rcc.o \
stm32f4xx_hal_rcc_ex.o \
stm32f4xx_hal_flash.o \
stm32f4xx_hal_flash_ex.o \
stm32f4xx_hal_flash_ramfunc.o \
stm32f4xx_hal_gpio.o \
stm32f4xx_hal_dma_ex.o \
stm32f4xx_hal_dma.o \
stm32f4xx_hal_pwr.o \
stm32f4xx_hal_pwr_ex.o \
stm32f4xx_hal_cortex.o \
stm32f4xx_hal.o \
stm32f4xx_hal_exti.o \
stm32f4xx_hal_pcd.o \
stm32f4xx_hal_pcd_ex.o \

OBJS += $(patsubst %,$(BUILD_DIR)/Drivers/STM32F4xx_HAL_Driver/Src/%,$(_OBJ))
C_SRCS += $(patsubst %,$(CubeF4_DIR)/Drivers/STM32F4xx_HAL_Driver/Src/%,$(_OBJ:.o=.c))
C_DEPS += $(patsubst %,$(BUILD_DIR)/Drivers/STM32F4xx_HAL_Driver/Src/%,$(_OBJ:.o=.d))

$(BUILD_DIR)/Drivers/STM32F4xx_HAL_Driver/Src/%.o: $(CubeF4_DIR)/Drivers/STM32F4xx_HAL_Driver/Src/%.c
	@printf "  CC\t$<\n"
	@mkdir -p $(dir $@)
	$(Q)$(CC) "$<" $(CFLAGS) -DUSE_HAL_DRIVER -DSTM32F411xE -c $(INCLUDES) -MF"$(@:%.o=%.d)" -MT"$@" -o "$@"
