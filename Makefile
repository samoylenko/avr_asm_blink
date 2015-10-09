CC = avra

MCU = ATtiny85
PRG = usbtiny
# PRG = avrispmkII

blink.hex: blink.asm
	$(CC) blink.asm

clean:
	rm -f *.obj *.hex *.cof

flash:	blink.hex
	sudo avrdude -p $(MCU) -c $(PRG) -U flash:w:blink.hex

programfuse:
	sudo avrdude -p $(MCU) -c $(PRG) -U lfuse:w:0x62:m -v -n

chipearase:
	sudo avrdude -p $(MCU) -c $(PRG) -e -v

