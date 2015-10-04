; Target device		: ATtiny85V
; Target frequency	: 1 Mhz

.include "atmel/tn45def.inc"

;=[ Code Segment ]======================================================

.cseg
.org 0x0000

;=[ Interrupts Table ]==================================================

	rjmp RESET			; RESET
	reti				; INT0
	reti				; PCINT0
	reti				; TIMER1_COMPA
	reti				; TIMER1_OVF
	reti				; TIMER0_OVF
	reti				; EE_RDY
	reti				; ANA_COMP
	reti				; ADC
	reti				; TIMER1_COMPB
	reti				; TIMER0_COMPA
	reti				; TIMER0_COMPB
	reti				; WDT
	reti				; USI_START
	reti				; USI_OVF

;=[ Program Start ]=====================================================

RESET:

;-[ Initialization ]------------------------------------------------

	; init stack
	ldi	r16, HIGH( RAMEND )
	out	SPH, r16
	ldi	r16, LOW( RAMEND )
	out	SPL, r16

	; disable unused devices
	; TODO: add more
	ldi	r16, 1 << ACD
	out	ACSR, r16

	; TODO: init interrupts


;-[ Main Routine ]--------------------------------------------------

MAIN_CYCLE:
	rjmp MAIN_CYCLE
