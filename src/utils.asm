.include "io.inc65"
.include "macros_65C02.inc65"

.zeropage
_delay_lo:				.res 1
_delay_hi:				.res 1

.setcpu		"65C02"
.smart		on
.autoimport	on
.case		on
.debuginfo	off
.importzp	sp, sreg, regsave, regbank, _in_char
.importzp	tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
.macpack	longbranch

.export _format_bank
.export _set_bank
.export _get_bank
.export __delay2
.export INPUT_CHK
.export _delay
.export _via_test
.export _echo_test
.export _INTE
.export _INTD
.export _GET_INT

.export __chrout
.export __output
.export __print
.export __newline

.segment "CODE"

__output:           JSR _GD_print_nl
                    JMP _acia_print_nl

__print:            JSR _GD_puts
                    JMP _acia_puts


__newline:          JSR _GD_newLine
                    JMP _acia_put_newline

__chrout:           JSR _GD_print
                    JMP _acia_putc


INPUT_CHK:    ;JMP _KBINPUT

              JSR _KBSCAN
        			BNE @prt
        			JSR _ACIA_SCAN
        			BEQ INPUT_CHK
@prt:   			;JSR _CHROUT
        			;JSR _GD_print
        			rts

_set_bank:
					STA BANK_BASE
					;CLC
					;ADC #$30
					;JSR _acia_putc
					RTS
_get_bank:  LDA BANK_BASE
            RTS


_echo_test:         JSR _GD_res_cur
@lll:               JSR _KBINPUT
                    STA _in_char
                    JSR _CHROUT
                    JMP _echo_test



_via_test:	LDA #$FF
						STA VIA2_DDRB
						LDA #$55
						STA VIA2_ORB
						JSR _delay
						LDA #$AA
						STA VIA2_ORB
						JSR _delay
						JMP _via_test

via_loop:			JSR _CHRIN
						STA VIA2_ORB
						JSR _CHROUT
						JMP via_loop
; ---------------------------------------------------------------
; void __near__ print_f (char *s)
; ---------------------------------------------------------------


_format_bank:
                  LDY #0
                  LDA #<(BANKDISK)
                  LDX #>(BANKDISK)
                  STA ptr1
                  STX ptr1 + 1

@write_BANK:			LDA #$0
                  STA (ptr1), Y
                  INY
                  CPY #$0
                  BNE @end_BANK
                  INX
                  STX ptr1 + 1
                  CPX #$C0
                  BNE @end_BANK
                  RTS
@end_BANK:			  JMP @write_BANK

_GET_INT:   LDA $CF20
            RTS

_INTE:  CLI
        RTS
_INTD:  SEI
        RTS


_delay:
  STA _delay_lo  ; save state
  LDA #$00
  STA _delay_hi  ; high byte
delayloop:
  ADC #01
  BNE delayloop
  CLC
  INC _delay_hi
  BNE delayloop
  CLC
  ; exit
  LDA _delay_lo  ; restore state
  RTS

__delay2:				LDX #$2
__delay3:				DEX
                BNE __delay3
                RTS
