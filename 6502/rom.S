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
	nop
	lda data
	ldx #$CA
	ldy #$FE
	stx $DEAD
	sty $BEAF
	jmp (addr)
data:
	.byte $5A
addr:
	.word reset

irq:
	rti

nmi:
	rti


	; CHR ROM data.
.segment "CHARS"
