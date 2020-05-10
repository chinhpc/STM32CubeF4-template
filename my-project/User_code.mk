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
freertos.o \
main.o \
stm32f4xx_hal_msp.o \
stm32f4xx_hal_timebase_tim.o \
stm32f4xx_it.o \
syscalls.o \
sysmem.o \
system_stm32f4xx.o \
usbd_cdc_if.o \
usbd_conf.o \
usbd_desc.o \
usb_device.o

U_OBJS += $(patsubst %,$(BUILD_DIR)/Src/%,$(_OBJ))
C_SRCS += $(patsubst %,Src/%,$(_OBJ:.o=.c))
C_DEPS += $(patsubst %,$(BUILD_DIR)/Src/%,$(_OBJ:.o=.d))

$(BUILD_DIR)/Src/%.o: Src/%.c
	@printf "  CC\t$<\n"
	@mkdir -p $(dir $@)
	$(Q)$(CC) "$<" $(CFLAGS) -DUSE_HAL_DRIVER -DSTM32F411xE -c $(INCLUDES) -MF"$(@:%.o=%.d)" -MT"$@" -o "$@"
