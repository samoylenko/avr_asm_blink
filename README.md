First steps in 8-bit AVR Assembly

This project is developed in Linux environment and compiled using 'avra' compiler  
It is supposed to be fully compatible with Atmel Studio, but I am yet to test it

| Parameter | Value |
|---------------|-----------|
| Target MCU		| ATtiny85V	|  
| Target frequency 	| 1 Mhz		|

| Make Command		| Description			|
|-----------------------|-------------------------------|
| make 			| Compiles the code into .hex	|
| make flash		| Program chip			|
| make chiperase	| Erase chip			|
| make programfuse	| Program fuses for 1 Mhz	|
| make clean            | Cleanup working files         |
