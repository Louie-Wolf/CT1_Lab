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
; -- CT1 P06 "ALU und Sprungbefehle" mit MUL
; --
; -- $Id: main.s 4857 2019-09-10 17:30:17Z akdi $
; ------------------------------------------------------------------
;Directives
        PRESERVE8
        THUMB

; ------------------------------------------------------------------
; -- Address Defines
; ------------------------------------------------------------------

ADDR_LED_15_0           EQU     0x60000100
ADDR_LED_31_16          EQU     0x60000102
ADDR_DIP_SWITCH_7_0     EQU     0x60000200
ADDR_DIP_SWITCH_15_8    EQU     0x60000201
ADDR_7_SEG_BIN_DS3_0    EQU     0x60000114
ADDR_BUTTONS            EQU     0x60000210

ADDR_LCD_RED            EQU     0x60000340
ADDR_LCD_GREEN          EQU     0x60000342
ADDR_LCD_BLUE           EQU     0x60000344
LCD_BACKLIGHT_FULL      EQU     0xffff
LCD_BACKLIGHT_OFF       EQU     0x0000
	
UPPER_BIT_MASK			EQU		0x0F
LOWER_BIT_MASK			EQU		0xF0

; ------------------------------------------------------------------
; -- myCode
; ------------------------------------------------------------------
        AREA myCode, CODE, READONLY

        ENTRY

main    PROC
        export main
            
; STUDENTS: To be programmed
		LDR		R7, =ADDR_DIP_SWITCH_7_0	;Load address of 0-7 switches
		LDRB	R0, [R7]					;Load byte of 0-7 switches in R0
		LDR		R1, =UPPER_BIT_MASK			;Load upper bit mask in R1
		ANDS	R0, R1						;Remove upper bits in R0
		
		LDR		R7, =ADDR_DIP_SWITCH_15_8	;Load address of 8-15 switches
		LDRB	R2, [R7]					;Load byte of 8-15 switches in R2
		LDR		R1, =UPPER_BIT_MASK			;Load upper bit mask in R1
		ANDS	R2, R1						;Remove lower bits in R2
		MOVS	R3, R2						;Copy content of R2 in R3
		;check for t0
		LDR		R7, =ADDR_BUTTONS
		LDRB	R6, [R7]
		LDR		R4, =UPPER_BIT_MASK
		ANDS	R6, R4
		CMP		R6, #0
		BHI		mode_b
		
mode_a	MOVS	R4, #10						;load 10 into R4
		MULS	R3, R4,R3					;multipy R3 by 10
		; use red blackground light
		LDR		R7, =ADDR_LCD_BLUE
		LDR		R6,	=LCD_BACKLIGHT_OFF
		STR		R6, [R7]
		LDR		R7, =ADDR_LCD_RED
		LDR		R6, =LCD_BACKLIGHT_FULL
		STR		R6, [R7]
		LDR		R7, =rest
		BX		R7
		
mode_b	MOVS	R4, #3
		MOVS	R5, R3 
		LSLS	R5, R4
		MOVS	R4, #1
		LSLS	R3,R4
		ADDS	R3, R3, R5
		;use blue background light
		LDR		R7, =ADDR_LCD_RED
		LDR		R6,	=LCD_BACKLIGHT_OFF
		STR		R6, [R7]
		LDR		R7, =ADDR_LCD_BLUE
		LDR		R6, =LCD_BACKLIGHT_FULL
		STR		R6, [R7]
		
rest	ADDS	R4, R3, R0					;Real number in binary
		MOVS 	R5,R4						;Copy real number to R5
		LSLS	R5,#8						;move to higher part of the word
		
		LSLS	R2,#4
		ORRS	R0,R2						;Lower Part of the half word in R0
		ORRS	R5, R5, R0					;combined half word			
		
		;display in leds
		LDR		R7, =ADDR_LED_15_0
		STRH	R5, [R7]
		;display in 7-seg
		LDR		R7, =ADDR_7_SEG_BIN_DS3_0
		STRH	R5, [R7]



; END: To be programmed

        B       main
        ENDP
            
;----------------------------------------------------
; Subroutines
;----------------------------------------------------

;----------------------------------------------------
; pause for disco_lights
pause           PROC
        PUSH    {R0, R1}
        LDR     R1, =1
        LDR     R0, =0x000FFFFF
        
loop        
        SUBS    R0, R0, R1
        BCS     loop
    
        POP     {R0, R1}
        BX      LR
        ALIGN
        ENDP

; ------------------------------------------------------------------
; End of code
; ------------------------------------------------------------------
        END
