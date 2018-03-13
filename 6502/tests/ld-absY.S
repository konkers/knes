.segment "HEADER"
.byte "NES", 26, 2, 1

.segment "VECTORS"
.word nmi, reset, irq

.segment "STARTUP"

.segment "CODE"

PPUCNT0 = $2000
PPUCNT1 = $2001
PPUSTATUS = $2002
PPUSCROLL = $2005
PPUADDR = $2006
PPUDATA = $2007

data00 = $0
data01 = $1
data05 = $2
data0A = $3
data0F = $4
data20 = $5
data40 = $6
data50 = $7
data5A = $8
data70 = $9
dataA0 = $A
dataA5 = $B
dataF0 = $C
dataFF = $D

	
reset:
	ldy #$3f
	lda #$5A
	sta $1000, Y
	lda #$A5
	sta $1080, Y
	lda #$FF
	sta $10EF, Y


	lda $1080, Y
	lda $10EF, Y
	lda $1000, Y

	ldx $1080, Y
	ldx $10EF, Y
	ldx $1000, Y

	stx $DEAD
loop:	
	jmp loop


irq:
	rti

nmi:
	rti


	; CHR ROM data.
.segment "CHARS"
