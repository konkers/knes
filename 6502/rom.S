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
	ldx #$FF
	lda #$5A
	ldx #$00
	tax

	lda #$00
	ldx #$FF
	tax

	lda #$80
	ldx #$2F
	tax

	
	CLC      ; 1 + 1 = 2, returns V = 0
	LDA #$01
	ADC #$01	
	
	CLC      ; -1 + 1 = 0, returns V = 0
	LDA #$FF 
	ADC #$01

	CLC      ; 127 + 1 = -128, returns V = 1
	LDA #$7F
	ADC #$01

	CLC      ; -128 + -1 = -129, returns V = 1
	LDA #$80
	ADC #$FF

	SEC      ; 0 - 1 = -1, returns V = 0
	LDA #$00
	SBC #$01

	SEC      ; -128 - 1 = -129, returns V = 1
	LDA #$80
	SBC #$01

	SEC      ; 127 - -1 = 128, returns V = 1
	LDA #$7F
	SBC #$FF

	stx $DEAD
loop:	
	jmp loop

data0:
	.byte $ff
data1:
	.byte $00
data2:
	.byte $01
irq:
	rti

nmi:
	rti


	; CHR ROM data.
.segment "CHARS"
