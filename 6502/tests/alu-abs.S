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
	clc
	lda #$00
	adc data20
	adc data70
	adc data70

	sec
	lda #$00
	adc data20
	adc data70
	adc data70

	;; these tests taken from http://www.6502.org/tutorials/vflag.html
	clc      ; 1 + 1 = 2, returns V = 0
	lda #$01
	adc data01	
	
	clc      ; -1 + 1 = 0, returns V = 0
	lda #$FF 
	adc data01

	clc      ; 127 + 1 = -128, returns V = 1
	lda #$7F
	adc data01

	clc      ; -128 + -1 = -129, returns V = 1
	lda #$80
	adc dataFF

	sec      ; 0 - 1 = -1, returns V = 0
	lda #$00
	sbc data01

	sec      ; -128 - 1 = -129, returns V = 1
	lda #$80
	sbc data01

	sec      ; 127 - -1 = 128, returns V = 1
	lda #$7F
	sbc dataFF

	sec      ; Note: SEC, not CLC
	lda #$3F ; 63 + 64 + 1 = 128, returns V = 1
	adc data40

	clc      ; Note: CLC, not SEC
	lda #$C0 ; -64 - 64 - 1 = -129, returns V = 1
	sbc data40

	clv
	
	lda #$5A
	and data0F
	and dataF0
	lda data5A
	and dataF0
	and data50
	and dataF0
	and dataA0

	clc
	lda #01
	sta $1001

	asl $1001
	asl $1001
	asl $1001
	asl $1001
	asl $1001
	asl $1001
	asl $1001
	asl $1001

	lda #$02
	sta $1001
	dec $1001
	dec $1001
	dec $1001

	lda #$00
	eor data05
	eor dataA0
	eor data0A
	eor data50
	eor data05
	eor dataA0
	eor data0A
	eor data50

	lda #$FE
	sta $1001
	inc $1001
	inc $1001
	inc $1001

	clc
	lda #$80
	sta $1001
	lsr $1001
	lsr $1001
	lsr $1001
	lsr $1001
	lsr $1001
	lsr $1001
	lsr $1001
	lsr $1001

	lda #$00
	ora data00
	ora data0A
	ora data50
	ora dataA0
	ora data05	

	sec
	lda #$00
	sta $1001
	rol $1001
	rol $1001
	rol $1001
	rol $1001
	rol $1001
	rol $1001
	rol $1001
	rol $1001
	rol $1001
	
	sec
	lda #$00
	sta $1001
	ror $1001
	ror $1001
	ror $1001
	ror $1001
	ror $1001
	ror $1001
	ror $1001
	ror $1001
	ror $1001

	stx $DEAD
loop:	
	jmp loop

data00:
	.byte $00
data01:
	.byte $01
data05:
	.byte $05
data0A:
	.byte $0A
data0F:
	.byte $0F
data20:
	.byte $20
data40:
	.byte $40
data50:
	.byte $50
data5A:
	.byte $5A
data70:
	.byte $70
dataA0:
	.byte $A0
dataA5:
	.byte $A5
dataF0:
	.byte $F0
dataFF:
	.byte $FF

irq:
	rti

nmi:
	rti


	; CHR ROM data.
.segment "CHARS"
