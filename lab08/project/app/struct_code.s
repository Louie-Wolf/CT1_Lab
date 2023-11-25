; ------------------------------------------------------------------
; --  _____       ______  _____                                    -
; -- |_   _|     |  ____|/ ____|                                   -
; --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
; --   | | | '_ \|  __|  \___ \   Zurich University of             -
; --  _| |_| | | | |____ ____) |  Applied Sciences                 -
; -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
; ------------------------------------------------------------------
; --
; -- main.s
; --
; -- CT1 P08 "Strukturierte Codierung" mit Assembler
; --
; -- $Id: struct_code.s 3787 2016-11-17 09:41:48Z kesr $
; ------------------------------------------------------------------
;Directives
        PRESERVE8
        THUMB

; ------------------------------------------------------------------
; -- Address-Defines
; ------------------------------------------------------------------
; input
ADDR_DIP_SWITCH_7_0       EQU        0x60000200
ADDR_BUTTONS              EQU        0x60000210

; output
ADDR_LED_31_0             EQU        0x60000100
ADDR_7_SEG_BIN_DS3_0      EQU        0x60000114
ADDR_LCD_COLOUR           EQU        0x60000340
ADDR_LCD_ASCII            EQU        0x60000300
ADDR_LCD_ASCII_BIT_POS    EQU        0x60000302
ADDR_LCD_ASCII_2ND_LINE   EQU        0x60000314
	
ADDR_LCD_BIN              EQU        0x60000330


; ------------------------------------------------------------------
; -- Program-Defines
; ------------------------------------------------------------------
; value for clearing lcd
ASCII_DIGIT_CLEAR        EQU         0x00000000
LCD_LAST_OFFSET          EQU         0x00000028

; offset for showing the digit in the lcd
ASCII_DIGIT_OFFSET        EQU        0x00000030

; lcd background colors to be written
DISPLAY_COLOUR_RED        EQU        0
DISPLAY_COLOUR_GREEN      EQU        2
DISPLAY_COLOUR_BLUE       EQU        4

; ------------------------------------------------------------------
; -- myConstants
; ------------------------------------------------------------------
        AREA myConstants, DATA, READONLY
; display defines for hex / dec
DISPLAY_BIT               DCB        "Bit "
DISPLAY_2_BIT             DCB        "2"
DISPLAY_4_BIT             DCB        "4"
DISPLAY_8_BIT             DCB        "8"
        ALIGN

; ------------------------------------------------------------------
; -- myCode
; ------------------------------------------------------------------
        AREA myCode, CODE, READONLY
        ENTRY

        ; imports for calls
        import adc_init
        import adc_get_value

main    PROC
        export main
        ; 8 bit resolution, cont. sampling
        BL         adc_init 
        BL         clear_lcd

main_loop
; STUDENTS: To be programmed
		
		;load adc in R0
		BL			adc_get_value
		
		;check if T0 is pressed 
		LDR			R7, =ADDR_BUTTONS
		LDRB		R1, [R7]
		MOVS		R2, #1
		ANDS		R1, R2
		
		;if T0 == isPressed
		BEQ			T0_NOT_PRESSED
		
		;LCD = green
		BL			clear_backlight
		LDR 		R7, =ADDR_LCD_COLOUR
		LDR			R1, =0xFFFF
		STRH		R1, [R7, #DISPLAY_COLOUR_GREEN]
		
		;display adc on 7-seg
		LDR			R7, =ADDR_7_SEG_BIN_DS3_0
		STR			R0, [R7]
		
		; Aufgabe b
		LSRS		R0, #3			;divide adc by 8 -> R0 = magnitude
		MOVS		R1, #1			;led bar
		
		;while (magintude > 0) magnitude--
FOR_MAGNITUDE_BEGIN
		CMP			R0, #0
		BEQ			FOR_MAGNITUDE_END
		
		LSLS		R1, #1
		ADDS		R1, #1
		
		SUBS		R0, #1
		B			FOR_MAGNITUDE_BEGIN
FOR_MAGNITUDE_END
		
		;LED = led bar
		LDR		R7, =ADDR_LED_31_0
		STR		R1, [R7]
		
		B		T0_PRESSED_END
		
T0_NOT_PRESSED ;else not pressed
		
		;read dip switch value
		LDR		R7, =ADDR_DIP_SWITCH_7_0
		LDRB	R1, [R7] 					;R0= adc, R1 = dip
		MOVS	R2, R1
		SUBS	R2, R0						;R2 (diff) = dip - adc
		
		;if diff < 0
		BLT		IF_DIFF_NEGATIVE
		
		;if diff >=0
		;display LCD blue
		BL		clear_backlight
		LDR		R7, =ADDR_LCD_COLOUR
		LDR		R3, =0xFFFF
		STRH	R3, [R7, #DISPLAY_COLOUR_BLUE]
		
		;Aufgabe C
		LDR		R6, =ADDR_LCD_ASCII
		LDR		R7, =DISPLAY_8_BIT
		
		CMP		R0, #4
		BGE		ELSE_IF_DIFF_LESS_THAN_16
		
		;if diff < 4
		LDR		R7, =DISPLAY_2_BIT
		B		END_IF_DIFF

ELSE_IF_DIFF_LESS_THAN_16
		CMP		R0, #16
		BGE		END_IF_DIFF
		
		;if diff < 16
		LDR		R7, =DISPLAY_4_BIT
		
END_IF_DIFF
		;write chosen bit
		LDR		R7, [R7]
		STRB	R7, [R6]
		
		;write bit to lcd
		BL		write_bit_ascii
		
		B		IF_DIFF_END
IF_DIFF_NEGATIVE
		
		;else if diff < 0
		
		;display lcd red
		BL		clear_backlight
		LDR		R7, =ADDR_LCD_COLOUR
		LDR		R3, =0xFFFF
		STRH	R3, [R7, #DISPLAY_COLOUR_RED]
		
		;Aufgabe d
		;diff in R2
		MOVS	R1, #0	;count
		MOVS	R3, #0	;i = 0
		
FOR_BIT
		CMP		R3, #32	; i < 32; i++
		BEQ		FOR_BIT_END
		
		LSLS	R2, #1
		
		;if currentDif[i] == zero -> count++
		BCS		BIT_SET
		ADDS	R1, #1
BIT_SET
		
		ADDS	R3, #1 ;i++
		B		FOR_BIT
FOR_BIT_END
		
		
		LDR		R7, =ADDR_LCD_BIN
		STR		R1, [R7]
		
IF_DIFF_END
		
		;display diff on seg
		LDR		R7, =ADDR_7_SEG_BIN_DS3_0
		STR		R0, [R7]
		
T0_PRESSED_END
		
		 
; END: To be programmed
        B          main_loop
		
clear_backlight
		PUSH		{R1,R7}
		
		LDR			R7, =ADDR_LCD_COLOUR
		LDR	    	R1, =0x0000
        STRH     	R1, [R7, #DISPLAY_COLOUR_RED]
		STRH		R1, [R7, #DISPLAY_COLOUR_GREEN]
        STRH    	R1, [R7, #DISPLAY_COLOUR_BLUE]
		
		POP			{R1,R7}
		BX			LR
        
clear_lcd
        PUSH       {R0, R1, R2}
        LDR        R2, =0x0
clear_lcd_loop
        LDR        R0, =ADDR_LCD_ASCII
        ADDS       R0, R0, R2                       ; add index to lcd offset
        LDR        R1, =ASCII_DIGIT_CLEAR
        STR        R1, [R0]
        ADDS       R2, R2, #4                       ; increas index by 4 (word step)
        CMP        R2, #LCD_LAST_OFFSET             ; until index reached last lcd point
        BMI        clear_lcd_loop
        POP        {R0, R1, R2}
        BX         LR

write_bit_ascii
        PUSH       {R0, R1}
        LDR        R0, =ADDR_LCD_ASCII_BIT_POS 
        LDR        R1, =DISPLAY_BIT
        LDR        R1, [R1]
        STR        R1, [R0]
        POP        {R0, R1}
        BX         LR

        ENDP
        ALIGN


; ------------------------------------------------------------------
; End of code
; ------------------------------------------------------------------
        END
