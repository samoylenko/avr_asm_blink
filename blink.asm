; Target device		: ATtiny85V
; Target frequency	: 1 Mhz

.include "atmel/tn85def.inc"

;=[ Code Segment ]======================================================

.cseg
.org 0x0000

;=[ Interrupts Table ]==================================================

	rjmp	RESET
	reti						;	rjmp	INT0_ISR
	reti						;	rjmp	PCINT0_ISR
	reti						;	rjmp	TIM1_COMPA_ISR
	reti						;	rjmp	TIM1_OVF_ISR
	rjmp	TIM0_OVF_ISR
	reti						;	rjmp	EE_RDY_ISR
	reti						;	rjmp	ANA_COMP_ISR
	reti						;	rjmp	ADC_ISR
	reti						;	rjmp	TIM1_COMPB_ISR
	reti						;	rjmp	TIM0_COMPA_ISR
	reti						;	rjmp	TIM0_COMPB_ISR
	reti						;	rjmp	WDT_ISR
	reti						;	rjmp	USI_START_ISR
	reti						;	rjmp	USI_OVF_ISR

;=[ Interrupt handlers ]================================================

TIM0_OVF_ISR:

	push	r16
	in		r16, SREG
	push	r16

	in		r16, PORTB
;	ldi		r17, ( 1 << PB4 )	; r17 is always PB4  
	eor		r16, r17		; invert PB4
	out		PORTB, r16

	pop		r16
	out		SREG, r16
	pop		r16
	reti


;=[ Program Start ]=====================================================

RESET:

;-[ Initialization ]------------------------------------------------

	; init stack
	ldi		r16, HIGH( RAMEND )
	out		SPH, r16
	ldi		r16, LOW( RAMEND )
	out		SPL, r16

	; disable unused devices
	; TODO: add more
	ldi		r16, ( 1 << ACD )
	out		ACSR, r16

	; configure port B
	ldi		r17, ( 1 << PORTB4 ) 	; everything but PB4 is input
	out		DDRB, r16
	clr		r16;
	out		PORTB, r16		; disabe pull-ups and set output to ground

	; init Timer 0 and enable interrupts
	; 1Mhz / 1024 / 256 overflow, ~3.8 events, ~2 blinks / sec
	ldi		r16, ( 1 << CS02 )|( 1 << CS00 )
	out		TCCR0B, r16
	ldi		r16, 1 << TOV0
	out		TIFR, r16
	ldi		r16, 1 << TOIE0
	out		TIMSK, r16 
	sei

;-[ Main Routine ]--------------------------------------------------

MAIN_CYCLE:
	sleep
	rjmp 	MAIN_CYCLE
