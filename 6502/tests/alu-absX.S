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
	ldx #$3f
	lda #$5A
	sta $1000, X
	sta $10f0, X

	clc
	adc $1000, X

	clc
	adc $10f0, X


	ldx #$3f
	lda #$5A
	sta $1000, X
	sta $10f0, X

	sec
	sbc $1000, X

	sec
	sbc $10f0, X

	ldx #$3f
	lda #$5A
	sta $1000, X
	lda #$A5
	sta $10f0, X

	lda #$FF
	and $1000, X
	and $10f0, X

	ldx #$3f
	lda #$5A
	sta $1000, X
	lda #$A5
	sta $10f0, X

	lda #$00
	ora $1000, X
	ora $10f0, X

	ldx #$3f
	lda #$5A
	sta $1000, X
	lda #$A5
	sta $10f0, X

	lda #$00
	eor $1000, X
	eor $10f0, X
	eor $1000, X
	eor $10f0, X

	ldx #$3f
	lda #$5A
	sta $1000, X
	lda #$A5
	sta $10f0, X
	lda #$00
	sta $1080, X

	lda #$5A
	cmp $1000, X
	cmp $10f0, X
	cmp $1080, X

	
	stx $DEAD
loop:	
	jmp loop


irq:
	rti

nmi:
	rti


	; CHR ROM data.
.segment "CHARS"
