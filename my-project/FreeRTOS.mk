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
croutine.o \
event_groups.o \
list.o \
queue.o \
stream_buffer.o \
tasks.o \
timers.o \
CMSIS_RTOS_V2/cmsis_os2.o \
portable/MemMang/heap_4.o \
portable/GCC/ARM_CM4F/port.o

OBJS += $(patsubst %,$(BUILD_DIR)/Middlewares/Third_Party/FreeRTOS/Source/%,$(_OBJ))
C_SRCS += $(patsubst %,$(CubeF4_DIR)/Middlewares/Third_Party/FreeRTOS/Source/%,$(_OBJ:.o=.c))
C_DEPS += $(patsubst %,$(BUILD_DIR)/Middlewares/Third_Party/FreeRTOS/Source/%,$(_OBJ:.o=.d))

$(BUILD_DIR)/Middlewares/Third_Party/FreeRTOS/Source/%.o: $(CubeF4_DIR)/Middlewares/Third_Party/FreeRTOS/Source/%.c
	@printf "  CC\t$<\n"
	@mkdir -p $(dir $@)
	$(Q)$(CC) "$<" $(CFLAGS) -DUSE_HAL_DRIVER -DSTM32F411xE -c $(INCLUDES) -MF"$(@:%.o=%.d)" -MT"$@" -o "$@"
