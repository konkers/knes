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
	lda #$00
	sta data00

	lda #$01
	sta data01

	lda #$05
	sta data05

	lda #$0A
	sta data0A
	
	lda #$0F
	sta data0F
	
	lda #$20
	sta data20

	lda #$40
	sta data40
	
	lda #$50
	sta data50

	lda #$5A
	sta data5A
	
	lda #$70
	sta data70
	
	lda #$A0
	sta dataA0
	
	lda #$A5
	sta dataA5
	
	lda #$F0
	sta dataF0
	
	lda #$FF
	sta dataFF

	ldx #$00
	
	clc
	lda #$00
	adc data20, X
	adc data70, X
	adc data70, X

	sec
	lda #$00
	adc data20, X
	adc data70, X
	adc data70, X

	;; these tests taken from http://www.6502.org/tutorials/vflag.html
	clc      ; 1 + 1 = 2, returns V = 0
	lda #$01
	adc data01, X	
	
	clc      ; -1 + 1 = 0, returns V = 0
	lda #$FF 
	adc data01, X

	clc      ; 127 + 1 = -128, returns V = 1
	lda #$7F
	adc data01, X

	clc      ; -128 + -1 = -129, returns V = 1
	lda #$80
	adc dataFF, X

	sec      ; 0 - 1 = -1, returns V = 0
	lda #$00
	sbc data01, X

	sec      ; -128 - 1 = -129, returns V = 1
	lda #$80
	sbc data01, X

	sec      ; 127 - -1 = 128, returns V = 1
	lda #$7F
	sbc dataFF, X

	sec      ; Note: SEC, not CLC
	lda #$3F ; 63 + 64 + 1 = 128, returns V = 1
	adc data40, X

	clc      ; Note: CLC, not SEC
	lda #$C0 ; -64 - 64 - 1 = -129, returns V = 1
	sbc data40, X

	clv
	
	lda #$5A
	and data0F, X
	and dataF0, X
	lda data5A, X
	and dataF0, X
	and data50, X
	and dataF0, X
	and dataA0, X

	ldx #$F0
	clc
	lda #01
	sta $21, X

	asl $21, X
	asl $21, X
	asl $21, X
	asl $21, X
	asl $21, X
	asl $21, X
	asl $21, X
	asl $21, X

	ldx #$40
	lda #$02
	sta $11, X
	dec $11, X
	dec $11, X
	dec $11, X

	ldx #$00
	
	lda #$00
	eor data05, X
	eor dataA0, X
	eor data0A, X
	eor data50, X
	eor data05, X
	eor dataA0, X
	eor data0A, X
	eor data50, X

	lda #$FE
	sta $11, X
	inc $11, X
	inc $11, X
	inc $11, X

	clc
	lda #$80
	sta $11, X
	lsr $11, X
	lsr $11, X
	lsr $11, X
	lsr $11, X
	lsr $11, X
	lsr $11, X
	lsr $11, X
	lsr $11, X

	lda #$00
	ora data00, X
	ora data0A, X
	ora data50, X
	ora dataA0, X
	ora data05, X

	sec
	lda #$00
	sta $11, X
	rol $11, X
	rol $11, X
	rol $11, X
	rol $11, X
	rol $11, X
	rol $11, X
	rol $11, X
	rol $11, X
	rol $11, X
	
	sec
	lda #$00
	sta $11, X
	ror $11, X
	ror $11, X
	ror $11, X
	ror $11, X
	ror $11, X
	ror $11, X
	ror $11, X
	ror $11, X
	ror $11, X

	stx $DEAD
loop:	
	jmp loop


irq:
	rti

nmi:
	rti


	; CHR ROM data.
.segment "CHARS"
