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
	lda #$20
	sta $0E
	lda #$10
	sta $0F
	lda #$5A
	ldx #$8E
	sta ($80,X)

	lda #$00
	lda ($80,X)
	
	stx $DEAD
loop:	
	jmp loop


irq:
	rti

nmi:
	rti


	; CHR ROM data.
.segment "CHARS"
