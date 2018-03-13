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
	sta $10f0, Y

	clc
	adc $1000, Y

	clc
	adc $10f0, Y


	ldy #$3f
	lda #$5A
	sta $1000, Y
	sta $10f0, Y

	sec
	sbc $1000, Y

	sec
	sbc $10f0, Y

	ldy #$3f
	lda #$5A
	sta $1000, Y
	lda #$A5
	sta $10f0, Y

	lda #$FF
	and $1000, Y
	and $10f0, Y

	ldy #$3f
	lda #$5A
	sta $1000, Y
	lda #$A5
	sta $10f0, Y

	lda #$00
	ora $1000, Y
	ora $10f0, Y

	ldy #$3f
	lda #$5A
	sta $1000, Y
	lda #$A5
	sta $10f0, Y

	lda #$00
	eor $1000, Y
	eor $10f0, Y
	eor $1000, Y
	eor $10f0, Y

	ldy #$3f
	lda #$5A
	sta $1000, Y
	lda #$A5
	sta $10f0, Y
	lda #$00
	sta $1080, Y

	lda #$5A
	cmp $1000, Y
	cmp $10f0, Y
	cmp $1080, Y

	
	stx $DEAD
loop:	
	jmp loop


irq:
	rti

nmi:
	rti


	; CHR ROM data.
.segment "CHARS"
