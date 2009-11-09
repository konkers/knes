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
	lda #$00
	lda #$5A
	lda #$80
	lda #$A5
	lda #$FF

	ldx #$00
	ldx #$5A
	ldx #$80
	ldx #$A5
	ldx #$FF

	ldy #$00
	ldy #$5A
	ldy #$80
	ldy #$A5
	ldy #$FF

	lda data0
	lda data1
	lda data2
	lda data3
	lda data4

	ldx data0
	ldx data1
	ldx data2
	ldx data3
	ldx data4

	ldy data0
	ldy data1
	ldy data2
	ldy data3
	ldy data4

	lda #$A5
	ldx #$5A
	ldy #$FF

	sta $2000
	stx $2001
	
	sty $DEAD
loop:	
	jmp loop

data0:
	.byte $00
data1:
	.byte $5A
data2:
	.byte $80
data3:
	.byte $A5
data4:
	.byte $FF

irq:
	rti

nmi:
	rti


	; CHR ROM data.
.segment "CHARS"
