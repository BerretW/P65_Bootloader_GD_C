.zeropage

.smart		on
.autoimport	on
.case		on
.debuginfo	off
.importzp	sp, sreg, regsave, regbank
.importzp	tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
.macpack	longbranch
.export	_CHROUT
.export	_CHRIN
.export	_PRNTLN
.export	_PRNT
.export	_PRNL
.export	_SETBNK
.export	_GETBNK
.export	_SNINIT
.export	_SNWRT
.export	_SHDLY
.export	_RST
.export	_KBINPUT
.export	_KBGET
.export	_KBSCAN
.export	_KBINIT
.export	_INPUT
.export	_DLY
.export	_INTEN
.export	_INTDI
.export	_GET_INTERRUPT
.export	_ACIA_SCAN
.export	_SPI_INIT
.export	_SPI_WRITE
.export	_GD_INIT
.export	_GD_CHROUT
.export	_GD_WRITE8
.export	_GD_CLR
.export	_GD_WRITE16
.export	_GD_SET_CUR




.segment "JMPTBL"

_CHROUT:	JMP	__chrout		;$FF00	print CHAR from regA
_CHRIN:	JMP	_acia_getc        		;$FF03	get char from buffer to regA
_PRNTLN:	JMP	__output		;$FF06	put new line and a string with start address in regA and regX "lda #<(STRING),ldx #>(STRING),jsr PRNTLN"
_PRNT:	JMP	__print		;$FF09	put a string with start address in regA and regX "lda #<(STRING),ldx #>(STRING),jsr PRNTLN"
_PRNL:	JMP	__newline		;$FF0C	print a new line
_SETBNK:	JMP	_set_bank         		;$FF0F	set bank to number from regA
_GETBNK:	JMP	_get_bank         		;$FF12	get bank number to regA
_SNINIT:	JMP	_sn_init          		;$FF15	Initialize SN76489 chipwith mute
_SNWRT:	JMP	_sn_write_data    		;$FF18	write data from regA to sn76489
_SHDLY:	JMP	__delay2          		;$FF1B	Short delay
_RST:	JMP	_main		;$FF1E	Restart to bootloader
_KBINPUT:	JMP	_kbinput          		;$FF21	get key from PS2 keyboard
_KBGET:	JMP	_kbget             		;$FF24
_KBSCAN:	JMP	_kbscan            		;$FF27
_KBINIT:	JMP	_kbinit            		;$FF2A	Initialise PS2 keyboard
_INPUT:	JMP	INPUT_CHK         		;$FF2D
_DLY:	JMP	_delay		;$FF30	Long delay
_INTEN:	JMP	_INTE		;$FF33	Enable Interrupts
_INTDI:	JMP	_INTD		;$FF36	Disable Interrupts
_GET_INTERRUPT:	JMP	_GET_INT		;$FF39	Get Interrupt number 0 = IRQ0, 2 = IRQ1, 4 = IRQ2, 6 = IRQ3, 8 = IRQ4, A = IRQ5, C = IRQ6, E = IRQ7
_ACIA_SCAN:	JMP	_acia_scan		;$FF3C	scan acia for character, if no return 0
_SPI_INIT:	JMP	_spi_init		;$FF3F	initialize SPI interface
_SPI_WRITE:	JMP	_spi_write		;$FF42	write data from A to SPI
_GD_INIT:	JMP	_GD_Init		;$FF45	initialize GD and clear screen
_GD_CHROUT:	JMP	_GD_print		;$FF48	Print character at cursor position
_GD_WRITE8:	JMP	_GD_WR_8		;$FF4B	write data to setup address
_GD_CLR:	JMP	_CLR_scr		;$FF4E	Clear screen
_GD_WRITE16:	JMP	_GD_WR_16		;$FF51	write 16bit data to setup address
_GD_SET_CUR:	JMP	_GD_set_cur_pos		;$FF54	set cursor position
