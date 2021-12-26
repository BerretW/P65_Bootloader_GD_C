.include "lcd.inc65"

.setcpu		"65C02"
.smart		on
.autoimport	on


.include "io.inc65"
.include "macros_65C02.inc65"
.include "zeropage.inc65"



.segment "ZEROPAGE"
.importzp	tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
.importzp tmpstack

.segment "CODE"
.export _lcd_init, _lcd_displayOn, _lcd_displayOff, _lcd_cursorBlinkOn

; -----------------------------------------------------------------------------
; lcdInit: Initialise the LCD
; -----------------------------------------------------------------------------
_lcd_init:
	jsr lcdWait
	lda #LCD_INITIALIZE
	sta LCD_CMD
	jsr lcdClear
	jsr lcdHome
	jsr _lcd_displayOn
	rts
  ; -----------------------------------------------------------------------------
  ; lcdClear: Clears the LCD
  ; -----------------------------------------------------------------------------
  lcdClear:
  	jsr lcdWait
  	lda #LCD_CMD_CLEAR
  	sta LCD_CMD
  	rts

  ; -----------------------------------------------------------------------------
  ; lcdHome: Return to the start address
  ; -----------------------------------------------------------------------------
  lcdHome:
  	jsr lcdWait
  	lda #LCD_CMD_HOME
  	sta LCD_CMD
  	rts

  ; -----------------------------------------------------------------------------
  ; lcdDisplayOn: Turn the display on
  ; -----------------------------------------------------------------------------
  _lcd_displayOn:
  	jsr lcdWait
  	lda #DISPLAY_MODE
  	sta LCD_CMD
  	rts

  ; -----------------------------------------------------------------------------
  ; lcdDisplayOff: Turn the display off
  ; -----------------------------------------------------------------------------
  _lcd_displayOff:
  	jsr lcdWait
  	lda #LCD_CMD_DISPLAY
  	sta LCD_CMD
  	rts

  ; -----------------------------------------------------------------------------
  ; lcdCursorOn: Show cursor
  ; -----------------------------------------------------------------------------
  lcdCursorOn:
  	jsr lcdWait
  	lda #DISPLAY_MODE | LCD_CMD_DISPLAY_CURSOR
  	sta LCD_CMD
  	rts

  ; -----------------------------------------------------------------------------
  ; lcdCursorOff: Hide cursor
  ; -----------------------------------------------------------------------------
  lcdCursorOff:
  	jsr lcdWait
  	lda #DISPLAY_MODE
  	sta LCD_CMD
  	rts

  ; -----------------------------------------------------------------------------
  ; lcdCursorBlinkOn: Show cursor
  ; -----------------------------------------------------------------------------
  _lcd_cursorBlinkOn:
  	jsr lcdWait
  	lda #DISPLAY_MODE | LCD_CMD_DISPLAY_CURSOR | LCD_CMD_DISPLAY_CURSOR_BLINK
  	sta LCD_CMD
  	rts

    ; -----------------------------------------------------------------------------
    ; lcdWait: Wait until the LCD is no longer busy
    ; -----------------------------------------------------------------------------
    ; Outputs:
    ;  A: Current LCD address
    ; -----------------------------------------------------------------------------
    lcdWait:
    	lda LCD_CMD
    	bmi lcdWait  ; branch if bit 7 is set
    	rts
