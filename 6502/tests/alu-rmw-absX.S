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
	lda #$01
	sta $1000, X
	sta $10f0, X

	clc
	asl $1000, X
	asl $1000, X
	asl $1000, X
	asl $1000, X
	asl $1000, X
	asl $1000, X
	asl $1000, X
	asl $1000, X

	clc
	asl $10f0, X
	asl $10f0, X
	asl $10f0, X
	asl $10f0, X
	asl $10f0, X
	asl $10f0, X
	asl $10f0, X
	asl $10f0, X

	ldx #$3f
	lda #$00
	sta $1000, X
	sta $10f0, X

	sec
	rol $1000, X
	rol $1000, X
	rol $1000, X
	rol $1000, X
	rol $1000, X
	rol $1000, X
	rol $1000, X
	rol $1000, X
	rol $1000, X

	sec
	rol $10f0, X
	rol $10f0, X
	rol $10f0, X
	rol $10f0, X
	rol $10f0, X
	rol $10f0, X
	rol $10f0, X
	rol $10f0, X
	rol $10f0, X
	
	ldx #$3f
	lda #$80
	sta $1000, X
	sta $10f0, X

	clc
	lsr $1000, X
	lsr $1000, X
	lsr $1000, X
	lsr $1000, X
	lsr $1000, X
	lsr $1000, X
	lsr $1000, X
	lsr $1000, X

	clc
	lsr $10f0, X
	lsr $10f0, X
	lsr $10f0, X
	lsr $10f0, X
	lsr $10f0, X
	lsr $10f0, X
	lsr $10f0, X
	lsr $10f0, X

	ldx #$3f
	lda #$00
	sta $1000, X
	sta $10f0, X

	sec
	ror $1000, X
	ror $1000, X
	ror $1000, X
	ror $1000, X
	ror $1000, X
	ror $1000, X
	ror $1000, X
	ror $1000, X
	ror $1000, X

	sec
	ror $10f0, X
	ror $10f0, X
	ror $10f0, X
	ror $10f0, X
	ror $10f0, X
	ror $10f0, X
	ror $10f0, X
	ror $10f0, X
	ror $10f0, X

	ldx #$3f
	lda #02
	sta $1000, X
	sta $10f0, X

	dec $1000, X
	dec $1000, X
	dec $1000, X
	dec $1000, X

	dec $10f0, X
	dec $10f0, X
	dec $10f0, X
	dec $10f0, X
	
	ldx #$3f
	lda #$FE
	sta $1000, X
	sta $10f0, X

	inc $1000, X
	inc $1000, X
	inc $1000, X
	inc $1000, X

	inc $10f0, X
	inc $10f0, X
	inc $10f0, X
	inc $10f0, X
	
	stx $DEAD
loop:	
	jmp loop


irq:
	rti

nmi:
	rti


	; CHR ROM data.
.segment "CHARS"
