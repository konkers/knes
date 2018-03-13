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

reset:
	lda #$5a
	sta $00
	lda #$a5
	sta $01
	lda #$FF
	sta $02
	lda #$80
	sta $03
	lda #$00
	sta $80
	lda #$01
	sta $ff

	ldy $00
	ldy $01
	ldy $02
	ldy $03
	ldy $80
	ldy $ff

	ldx #$5a
	stx $00
	ldx #$a5
	stx $01
	ldx #$FF
	stx $02
	ldx #$80
	stx $03
	ldx #$00
	stx $80
	ldx #$01
	stx $ff
	
	lda $00
	lda $01
	lda $02
	lda $03
	lda $80
	lda $ff
	
	ldy #$5a
	sty $00
	ldy #$a5
	sty $01
	ldy #$FF
	sty $02
	ldy #$80
	sty $03
	ldy #$00
	sty $80
	ldy #$01
	sty $ff

	ldx $00
	ldx $01
	ldx $02
	ldx $03
	ldx $80
	ldx $ff
	
	stx $DEAD
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
