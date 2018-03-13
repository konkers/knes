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
	clc
	lda #$00
	adc #$20
	adc #$70
	adc #$70

	sec
	lda #$00
	adc #$20
	adc #$70
	adc #$70

	;; these tests taken from http://www.6502.org/tutorials/vflag.html
	clc      ; 1 + 1 = 2, returns V = 0
	lda #$01
	adc #$01	
	
	clc      ; -1 + 1 = 0, returns V = 0
	lda #$FF 
	adc #$01

	clc      ; 127 + 1 = -128, returns V = 1
	lda #$7F
	adc #$01

	clc      ; -128 + -1 = -129, returns V = 1
	lda #$80
	adc #$FF

	sec      ; 0 - 1 = -1, returns V = 0
	lda #$00
	sbc #$01

	sec      ; -128 - 1 = -129, returns V = 1
	lda #$80
	sbc #$01

	sec      ; 127 - -1 = 128, returns V = 1
	lda #$7F
	sbc #$FF

	sec      ; Note: SEC, not CLC
	lda #$3F ; 63 + 64 + 1 = 128, returns V = 1
	adc #$40

	clc      ; Note: CLC, not SEC
	lda #$C0 ; -64 - 64 - 1 = -129, returns V = 1
	sbc #$40

	clv
	
	lda #$5A
	and #$0F
	and #$F0
	lda #$5A
	and #$F0
	and #$50
	and #$F0
	and #$A0

	clc
	lda #01

	asl
	asl
	asl
	asl
	asl
	asl
	asl
	asl

	clc
	lda #$7F
	cmp #$7F
	cmp #$00
	cmp #$10
	cmp #$80
	cmp #$90
	cmp #$FF

	lda #$FF
	cmp #$7F
	cmp #$00
	cmp #$10
	cmp #$80
	cmp #$90
	cmp #$FF

	ldx #$7F
	cpx #$7F
	cpx #$00
	cpx #$FF

	ldy #$7F
	cpy #$7F
	cpy #$00
	cpy #$FF

	ldx #$02
	dex
	dex
	dex

	ldy #$02
	dey
	dey
	dey

	lda #$00
	eor #$05
	eor #$A0
	eor #$0A
	eor #$50
	eor #$05
	eor #$A0
	eor #$0A
	eor #$50

	ldx #$FE
	inx
	inx
	inx

	ldy #$FE
	iny
	iny
	iny

	clc
	lda #$80
	lsr
	lsr
	lsr
	lsr
	lsr
	lsr
	lsr
	lsr

	lda #$00
	ora #$00
	ora #$0A
	ora #$50
	ora #$A0
	ora #$05	

	sec
	lda #$00
	rol
	rol
	rol
	rol
	rol
	rol
	rol
	rol
	rol
	
	sec
	lda #$00
	ror
	ror
	ror
	ror
	ror
	ror
	ror
	ror
	ror

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
