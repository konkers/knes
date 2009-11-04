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
count:
	ldx #$00
	stx $DEAD
	ldx #$01
	stx $DEAD
	ldx #$02
	stx $DEAD
	ldx #$03
	stx $DEAD
	ldx #$04
	stx $DEAD
	ldx #$05
	stx $DEAD
	ldx #$06
	stx $DEAD
	ldx #$07
	stx $DEAD
	ldx #$08
	stx $DEAD
	ldx #$09
	stx $DEAD
	ldx #$0A
	stx $DEAD
	ldx #$0B
	stx $DEAD
	ldx #$0C
	stx $DEAD
	ldx #$0D
	stx $DEAD
	ldx #$0E
	stx $DEAD
	ldx #$0F
	stx $DEAD
	jmp (addr)
data:
	.byte $5A
addr:
	.word count

irq:
	rti

nmi:
	rti


	; CHR ROM data.
.segment "CHARS"
