; Target device		: ATtiny85V
; Target frequency	: 1 Mhz

; PB4 = LED indicator
; PB3 = Button (connects pin to ground when pressed)

.include "atmel/tn85def.inc"

;=[ Code Segment ]======================================================

.cseg
.org 0x0000

;=[ Interrupts Table ]==================================================

	rjmp	RESET
	reti				;	rjmp	INT0_ISR
	rjmp	PCINT0_ISR
	reti				;	rjmp	TIM1_COMPA_ISR
	reti				;	rjmp	TIM1_OVF_ISR
	rjmp	TIM0_OVF_ISR
	reti				;	rjmp	EE_RDY_ISR
	reti				;	rjmp	ANA_COMP_ISR
	reti				;	rjmp	ADC_ISR
	reti				;	rjmp	TIM1_COMPB_ISR
	reti				;	rjmp	TIM0_COMPA_ISR
	reti				;	rjmp	TIM0_COMPB_ISR
	reti				;	rjmp	WDT_ISR
	reti				;	rjmp	USI_START_ISR
	reti				;	rjmp	USI_OVF_ISR

;=[ Interrupt handlers ]================================================

;-[ Pin Change Interrupt - Button Pressed ]-------------------------

PCINT0_ISR:
	push	r16
	in	r16, SREG
	push	r16

	in	r16, PORTB
;	ldi	r17, ( 1 << PB4 )	; r17 is always PB4
	eor	r16, r17		; invert PB4
	out	PORTB, r16

	pop	r16
	out	SREG, r16
	pop	r16
	reti

;-[ Timer0 Overflow interrupt - 1/61 sec passed ]-------------------

TIM0_OVF_ISR:
	push	r16
	in	r16, SREG
	push	r16

	dec	r19
	brne	TIM0_OVF_ISR_exit	; exit if r19 is not 0

	ldi	r19, 61
	in	r16, PORTB
;	ldi	r17, ( 1 << PB4 )	; r17 is always PB4
	eor	r16, r17		; invert PB4
	out	PORTB, r16

TIM0_OVF_ISR_exit:

	pop	r16
	out	SREG, r16
	pop	r16

	reti

;=[ Program Start ]=====================================================

RESET:

;-[ Initialization ]------------------------------------------------

	; global variables
	ldi	r17, ( 1 << PB4 )	; r17 = PB4
	ldi	r19, 61			; r19 = 61 events counter for tim0ovf int	

	; init stack
	ldi	r16, HIGH( RAMEND )
	out	SPH, r16
	ldi	r16, LOW( RAMEND )
	out	SPL, r16

	; configure port B
;	ldi	r17, ( 1 << PB4 ) 	; everything but PB4 is input
	out	DDRB, r17
	ldi	r16, ( 1 << PB3 )	; enable pull-up at PB3 and set output to ground
	out	PORTB, r16

;-[ Interrupts initialization ]-------------------------------------

	; Pin Change Interrupt at PB3
	ldi	r16, ( 1 << PCIE )	; enable pin change interrupt
	out	GIMSK, r16
	ldi	r16, ( 1 << PCINT3 )	; watch PCINT3 (PB3)
	out	PCMSK, r16

	; Init Timer0
	; 1Mhz / 64 / 256 = 61 events / second

	ldi	r16, ( 1 << CS01 )|( 1 << CS00 )	; set source internal clock with 64 prescaler mode
	out	TCCR0B, r16
	ldi	r16, ( 1 << TOIE0 )			; Timer/Counter0 Overflow Interrupt Enable
	out	TIMSK, r16

	; Enable interrupts
	clr	r16					; clear interrupts
	out	GIFR, r16
	out	TIFR, r16
	out	TCNT0, r16
	sei						; enable interrupts

;-[ Main Routine ]--------------------------------------------------

MAIN_CYCLE:
	sleep
	rjmp 	MAIN_CYCLE
