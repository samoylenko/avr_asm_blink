CC = avra

first.hex: first.asm
	$(CC) first.asm

clean:
	rm -f *.obj *.hex *.cof
