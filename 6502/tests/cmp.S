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
	cmp data0
	cmp data1
	cmp data2
	cmp data3
	cmp data4

	lda #$5A
	cmp data0
	cmp data1
	cmp data2
	cmp data3
	cmp data4
	
	lda #$80
	cmp data0
	cmp data1
	cmp data2
	cmp data3
	cmp data4
	
	lda #$A5
	cmp data0
	cmp data1
	cmp data2
	cmp data3
	cmp data4
	
	lda #$FF
	cmp data0
	cmp data1
	cmp data2
	cmp data3
	cmp data4

	ldx #$00
	cpx data0
	cpx data1
	cpx data2
	cpx data3
	cpx data4

	ldx #$5A
	cpx data0
	cpx data1
	cpx data2
	cpx data3
	cpx data4
	
	ldx #$80
	cpx data0
	cpx data1
	cpx data2
	cpx data3
	cpx data4
	
	ldx #$A5
	cpx data0
	cpx data1
	cpx data2
	cpx data3
	cpx data4
	
	ldx #$FF
	cpx data0
	cpx data1
	cpx data2
	cpx data3
	cpx data4
	
	ldy #$00
	cpy data0
	cpy data1
	cpy data2
	cpy data3
	cpy data4

	ldy #$5A
	cpy data0
	cpy data1
	cpy data2
	cpy data3
	cpy data4
	
	ldy #$80
	cpy data0
	cpy data1
	cpy data2
	cpy data3
	cpy data4
	
	ldy #$A5
	cpy data0
	cpy data1
	cpy data2
	cpy data3
	cpy data4
	
	ldy #$FF
	cpy data0
	cpy data1
	cpy data2
	cpy data3
	cpy data4

	
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
