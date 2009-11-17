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
	lda #$3f
	sta $5E
	lda #$10
	sta $5F

	lda #$2f
	sta $4E
	lda #$11
	sta $4F

	lda #$Bf
	sta $DE
	lda #$10
	sta $DF

	
	ldx #$5E
	lda #$5A
	sta ($00,X)
	sta ($f0,X)

	clc
	adc ($00, X)

	clc
	adc ($f0, X)


	ldx #$5E
	lda #$5A
	sta ($00, X)
	sta ($f0, X)

	sec
	sbc ($00, X)

	sec
	sbc ($f0, X)

	ldx #$5E
	lda #$5A
	sta ($00, X)
	lda #$A5
	sta ($f0, X)

	lda #$FF
	and ($00, X)
	and ($f0, X)

	ldx #$5E
	lda #$5A
	sta ($00, X)
	lda #$A5
	sta ($f0, X)

	lda #$00
	ora ($00, X)
	ora ($f0, X)

	ldx #$5E
	lda #$5A
	sta ($00, X)
	lda #$A5
	sta ($f0, X)

	lda #$00
	eor ($00, X)
	eor ($f0, X)
	eor ($00, X)
	eor ($f0, X)

	ldx #$5E
	lda #$5A
	sta ($00, X)
	lda #$A5
	sta ($f0, X)
	lda #$00
	sta ($80, X)

	lda #$5A
	cmp ($00, X)
	cmp ($f0, X)
	cmp ($80, X)

	
	stx $DEAD
loop:	
	jmp loop


irq:
	rti

nmi:
	rti


	; CHR ROM data.
.segment "CHARS"
