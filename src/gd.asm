.include "io.inc65"
.include "gd.inc65"
.include "macros_65C02.inc65"
.include "zeropage.inc65"


	.fopt		compiler,"cc65 v 2.19 - Git a861d84"
	.setcpu		"65C02"
	.smart		on
	.autoimport	on
	.case		on
	.debuginfo	off
	.importzp	sp, sreg, regsave, regbank, _spr, tmpstack
	.importzp	tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
	.macpack	longbranch
	.export _GD_print_char
	.export _GD_print
	.export _GD_WR_8
	.export _GD_WR_16
	.export _GD_puts
	.export _GD_print_nl
	.export _GD_newLine
	.export _GD_RD_8
	.export __GD_putchar
	.export _GD_pos_to_addr
	.export _GD_res_cur
	.export _GD_set_cur_pos

	;.exportzp _in_char


.segment	"CODE"



; ---------------------------------------------------------------
; GD_res_cur
; ---------------------------------------------------------------
_GD_res_cur:	STZ _posx
							STZ _posy
							RTS



; ---------------------------------------------------------------
; void GD_wr_8(char * addr, char data)
; ldx     #$28	HiByte of address
; lda     #$09	LoByte of address
; jsr     pushax
; lda     #$01		data to write
; jsr     _GD_wr
; in A = data to write
; ---------------------------------------------------------------
_GD_WR_8: 		jsr     pusha
							ldy     #$02
							jsr     ldaxysp
							jsr     __wstart
							lda     (sp)
							jsr     _spi_write
							jsr     __end
							jmp     incsp3

; --------------------------------------------------------------
; void GD_wr_16(char * addr, char data)
; ldx     #$28	HiByte of address
; lda     #$09	LoByte of address
; jsr     pushax
; lda     #$01		HiByte of data to write
; ldx			#$00		LoByte of data to write
; jsr     _GD_wr_16
; in A = data to write
; ---------------------------------------------------------------
_GD_WR_16: 			jsr     pushax
								ldy     #$03
								jsr     ldaxysp
								jsr     __wstart
								jsr     ldax0sp
								jsr     _spi_write_16_data
								jsr     __end
								jmp     incsp4
; ---------------------------------------------------------------
;	GD_rd
; in X = Hibyte of address
; in A = Lobyte of address
; out A = return byte
; return
; ---------------------------------------------------------------
_GD_RD_8:		TAY
						LDA #14
						JSR _spi_begin
						TYA

						JSR _spi_write_16_addr

						LDA #$0
						JSR _spi_read
						STA ptr1
						JSR _spi_end
						LDA ptr1
						RTS


; void GD_puts(const char * s)
; Send the zero terminated string pointed to by A/X
; @in A/X (s) pointer to the string to send
; @mod ptr1
_GD_puts:						phaxy
										sta ptr1
										stx ptr1+1
										ldy #0
@next_char:					lda (ptr1),y
										STA _in_char
										BEQ @end

										PHY

										LDX _posx
										LDA _posy
										JSR __GD_putchar
										INC _posx

										PLY

										INY
										BNE @next_char
@end:								plaxy
										RTS


; ---------------------------------------------------------------
; void GD_newline
; increase line number and set cursor to start of line
; ---------------------------------------------------------------
_GD_newLine:			INC _posy
									STZ _posx
									RTS

; ---------------------------------------------------------------
; void GD_print_nl(const char * s)
; increase line number and set cursor to start of line
; and print string to new position
; ---------------------------------------------------------------

_GD_print_nl:			phax
									JSR _GD_puts
									JSR _GD_newLine
									plax
									RTS
; ---------------------------------------------------------------
; void GD_putchar (char c)
; Put character at cursor position
; in X = position at x
; in A = position at y
; in _in_char = Char to print
; ---------------------------------------------------------------

__GD_putchar:	LDY _in_char
							BEQ @end
							CLC
							CLD
							JSR _GD_pos_to_addr
							JSR __wstart
							LDA _in_char
							JSR _spi_write
							JSR __end
@end:					JMP incsp1

; ---------------------------------------------------------------
; void get_cursor_pos ()
; out X = position of cursor at x 0 - 49
; out Y = position of cursor at y 0 - 36
;
; ---------------------------------------------------------------
_get_cursor_pos: 	LDX _posx
									LDA _posy
									RTS


; ---------------------------------------------------------------
;	lda     #$01 ;pos X
;	jsr     pusha
;	lda     #$0F ;pos Y
; void GD_set_cur_pos (char x, char y)
; ---------------------------------------------------------------

_GD_set_cur_pos:	jsr     pusha
									lda     (sp)
									sta     _posy
									ldy     #$01
									lda     (sp),y
									sta     _posx
									jmp     incsp2


; ---------------------------------------------------------------
; _GD_pos_to_addr
; in A = position of cursor at y 0 - 36
; in X = position of cursor at x 0 - 49
; out X = addr HiByte from A>>6
; out A = addr lOByte from A1,A0,X5,X6,X4,X3,X2,X1,X0
; ---------------------------------------------------------------
_GD_pos_to_addr:	CLD
									PHX						;save X							X	= 1111 1111
									PHA						;save A							A	= 1111 1111
									AND #$FC			;mask lo 2 bites A 	A	= 1111 1100
									ROR						;Shift A						A	- 0111 1110
									ROR						;Shift A						A	- 0011 1111
									TAX						;save A to X				X	= 0011 1111
									PLA						;load saved A to A	A	=	1111 1111
									AND #$03			;mask Hi 6 bites		A	= 0000 0011
									ROR						;Shift A						A	- 0000 0001 C
									ROR						;Shift A						A	- 1000 0000 C
									ROR						;Shift A						A	- 1100 0000
									STA tmp2			;save A to tmp2		tmp2= 1100 0000
									PLA						;Load saved X to A	A	= 1111 1111
									AND #$3F			;mask top 2 bites		A	=	0011 1111
									ADC tmp2			;combine A and tmp2	A	=	1111 1111
@end:							RTS
; ---------------------------------------------------------------
; void GD_print_char()
; in A = char to print
; ---------------------------------------------------------------
_GD_print: 				CLD
									CLC
									JSR _check_char
_GD_print_char:		JSR _get_cursor_pos
									JSR __GD_putchar
									LDA _in_char
									BEQ @end
									JSR _GD_next_pos
@end:							RTS

; --------------------------------------------------------------
; void _check_char
; check if in A is printable character, if not then set Z = 1
; --------------------------------------------------------------
_check_char:	LDA _in_char
							BEQ @end
							CMP #$94
							BEQ @left
							CMP #$96
							BEQ @right
							CMP #$98
							BEQ @up
							CMP #$92
							BEQ @down
							CMP #$08
							BEQ @bksp
							CMP #$0D
							BEQ @ent
							CMP #$7F
							BEQ @bksp
							RTS

@left:				JSR _GD_prev_pos
							JSR _GD_prev_pos
							STZ _in_char
							RTS

@right:				JSR _GD_next_pos
							STZ _in_char
							RTS

@up:					JSR _GD_move_UP
							STZ _in_char
							JSR _GD_prev_pos
							RTS

@down:				JSR _GD_move_DOWN
							STZ _in_char
							JSR _GD_prev_pos
							RTS

@del:					JSR _GD_next_pos
							LDA #$20
							STA _in_char
							JSR _get_cursor_pos
							JSR __GD_putchar
							STZ _in_char
							RTS

@ent:					STZ _in_char
							JSR _GD_move_DOWN
							JSR _GD_prev_pos
							RTS

@bksp:				JSR _GD_prev_pos
							LDA #$20
							STA _in_char
							JSR _get_cursor_pos
							JSR __GD_putchar
							STZ _in_char
@end:					RTS
; --------------------------------------------------------------
; void GD_prev_pos()
; update position of cursor by 1 character left
; --------------------------------------------------------------
_GD_prev_pos:	LDX _posx
							BNE @_decx
							LDX #50
							STX _posx
							DEC _posy
@_decx:				DEX
							STX _posx
@end:					RTS

; --------------------------------------------------------------
; _GD_move_UP
; update position of cursor by 1 character left
; --------------------------------------------------------------
_GD_move_UP:	LDX _posy
							BNE @end
							LDX #37
@end:					DEX
							STX _posy
							RTS

; --------------------------------------------------------------
; _GD_move_UP
; update position of cursor by 1 character left
; --------------------------------------------------------------
_GD_move_DOWN:LDX _posy
							CPX #36
							BNE @end
							LDX #$0
							STX _posy
							RTS
@end:					INX
							STX _posy

							RTS
; ---------------------------------------------------------------
; void GD_next_pos ()
; update position of cursor by 1 character right
; ---------------------------------------------------------------
_GD_next_pos:	LDX _posx
							LDY _posy
							PHA
							PLA
							BEQ @end
							INX
							CPX #50
							BNE @end
							LDX #0
							STX _posx
							INY
							CPY #37
							BNE @end
							LDY #0
							STY _posy
@end:					STX _posx
							STY _posy
							RTS
