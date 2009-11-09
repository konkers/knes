.segment "HEADER"
.byte "NES", 26, 2, 1

.segment "VECTORS"
.word 0, 0, 0, nmi, reset, irq

.segment "STARTUP"

.segment "CODE"

PPUCNT0 = $2000
PPUCNT1 = $2001
PPUSTATUS = $2002
PPUSCROLL = $2005
PPUADDR = $2006
PPUDATA = $2007

reset:
	jmp j0
	nop 
j0:

	jmp (addr)
	nop
j1:	
	nop
	
	clc
	cld
	cli
	clv
	sec
	sed
	sei
	clc
	cld
	cli

	lda #$7F
	adc #$01
	clv

	clc
	bcs a0
	bcc a0
	nop
a0:	

	sec
	bcc a1
	bcs a1
	nop
a1:	

	lda #$FF
	bpl a2
	bmi a2
	nop
a2:

	lda #$0F
	bmi a3
	bpl a3
	nop
a3:	

	lda #$00
	bne a4
	beq a4
	nop
a4:	

	lda #$01
	beq a5
	bne a5
	nop
a5:

	lda #$7F
	adc #$01
	bvc a6
	bvs a6
	nop
a6:

	clv
	bvs a7
	bvc a7
	nop
a7:
	

	
	stx $DEAD
loop:	
	jmp loop

addr:
	.word j1
	
irq:
	rti

nmi:
	rti


	; CHR ROM data.
.segment "CHARS"
