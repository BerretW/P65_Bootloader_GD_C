
;SPI registerss

SPI_DATA   = $CF60
SPI_CSSEL		=	SPI_DATA + 3
SPI_STATUS	=	SPI_DATA + 1
SPI_DIV     = SPI_DATA + 2
SPI_CS			= $0			;CS0 = 14, CS1=13, CS2=11, CS3=7


;.import popa, popax
.importzp tmp1, tmp2,tmp3


data = tmp1
adrH = tmp2
adrL = tmp3

;.export _spi_write_to
.export _spi_begin
.export _spi_end
.export _spi_write
.export _spi_write_16_addr
.export _spi_write_16_data
.export _spi_read
.export _spi_init
.code



; void spi_write_to(char * buffer, char c)
; @in A (n) char to write
; @in popax (buffer) address in SPI

;_spi_write_to:      STA tmp1
;										JSR popax
;										STA tmp3
;										STX tmp2
;										LDA #$7
;										STA SPI_CSSEL
;										LDA tmp2
;										ADC #$80
;										JSR _spi_write
;										LDA tmp3
;										JSR _spi_write
;										LDA tmp1
;										JSR _spi_write
;										LDA #$F
;										STA SPI_CSSEL
;                    RTS

_spi_init:					LDA #4
										STA SPI_STATUS
										RTS

_spi_write:					STA SPI_DATA
										JSR spi_delay
										;JSR spi_delay
										;JSR spi_delay
										RTS

_spi_write_16_addr:	PHA
										TXA
										JSR _spi_write
										PLA
										JSR _spi_write
										RTS
_spi_write_16_data:
										JSR _spi_write
										TXA
										JSR _spi_write
										RTS

_spi_read:					STA SPI_DATA
										LDA SPI_DATA
										RTS

_spi_begin:					;LDA #0			;CS0 = 14, CS1=13, CS2=11, CS3=7
										STA SPI_CSSEL
										RTS

_spi_end:						PHA
										LDA #$F
										STA SPI_CSSEL
										PLA
										RTS

spi_delay:					LDY #$1
@_delay_1:					DEY
										BNE @_delay_1
										RTS
