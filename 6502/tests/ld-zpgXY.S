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
	ldx #$00
st_loop0:
	txa
	eor #$FF
	sta $80, X
	inx
	bne st_loop0

	ldx #$00
ld_loop0:
	lda $80, X
	inx
	bne ld_loop0

	lda #$00
	ldx #$00
	ldy #$FF
st_loop1:
	sty $80, X
	dey
	inx
	bne st_loop1
	
	ldx #$00
	ldy #$00
ld_loop1:
	ldy $80, X
	inx
	bne ld_loop1
	
	ldy #$00
	ldx #$FF
st_loop2:
	stx $80, Y
	dex
	iny
	bne st_loop2

	ldy #$00
	ldx #$00
ld_loop2:
	ldx $80, Y
	iny
	bne ld_loop2
	

	stx $DEAD
loop:	
	jmp loop


irq:
	rti

nmi:
	rti


	; CHR ROM data.
.segment "CHARS"
