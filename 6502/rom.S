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

	.repeat	$f8, I
	.byte I
	.endrep
reset:
	ldx #$FE
	lda data1
	beq loop
back:	
	adc #$01
        adc #$01
        adc #$01
	ldx #$FE

loop:	
	inx
	beq back
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
