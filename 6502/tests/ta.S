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
	lda #$a5
	ldx #$00
	tax

	lda #$5a
	ldx #$FF
	tax

	lda #$00
	ldx #$FF
	tax

	lda #$a5
	ldy #$00
	tay

	lda #$5a
	ldy #$FF
	tay

	lda #$00
	ldy #$FF
	tay
	
	ldx #$a5
	lda #$00
	txa

	ldx #$5a
	lda #$FF
	txa

	ldx #$00
	lda #$FF
	txa

	ldy #$a5
	lda #$00
	tya

	ldy #$5a
	lda #$FF
	tya

	ldy #$00
	lda #$FF
	tya

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
