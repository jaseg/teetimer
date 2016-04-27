# Makefile to build light_ws2812 library examples
# This is not a very good example of a makefile - the dependencies do not work, therefore everything is rebuilt every time.

# Change these parameters for your device

F_CPU = 1000000
DEVICE = attiny44

CFLAGS = -g2 -I. -Ilight_ws2812/light_ws2812_AVR/Light_WS2812 -mmcu=$(DEVICE) -DF_CPU=$(F_CPU) 
CFLAGS+= -Os -ffunction-sections -fdata-sections -fpack-struct -fno-move-loop-invariants -fno-tree-scev-cprop -fno-inline-small-functions  
CFLAGS+= -Wall -Wno-pointer-to-int-cast
#CFLAGS+= -Wa,-ahls=$<.lst

LDFLAGS = -Wl,--relax,--section-start=.text=0,-Map=main.map

main.elf: main.c
	avr-gcc $(CFLAGS) -o $@ $^
	avr-size $@

.PHONY: program
program: main.elf
	avrdude -v -c avrispmkII -p t44 -U flash:w:$<

.PHONY: fusebits
fusebits:
	avrdude -v -F -c avrispmkII -p t44 -U lfuse:w:0x62:m -U hfuse:w:0xdf:m -U efuse:w:0xff:m

.PHONY:	clean
clean:
	rm -f main.elf
