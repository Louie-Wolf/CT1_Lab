; ------------------------------------------------------------------
; --  _____       ______  _____                                    -
; -- |_   _|     |  ____|/ ____|                                   -
; --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
; --   | | | '_ \|  __|  \___ \   Zurich University of             -
; --  _| |_| | | | |____ ____) |  Applied Sciences                 -
; -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
; ------------------------------------------------------------------
; --
; -- table.s
; --
; -- CT1 P04 Ein- und Ausgabe von Tabellenwerten
; --
; -- $Id: table.s 800 2014-10-06 13:19:25Z ruan $
; ------------------------------------------------------------------
;Directives
        PRESERVE8
        THUMB
; ------------------------------------------------------------------
; -- Symbolic Literals
; ------------------------------------------------------------------
ADDR_DIP_SWITCH_7_0         EQU     0x60000200
ADDR_DIP_SWITCH_15_8        EQU     0x60000201
ADDR_DIP_SWITCH_31_24       EQU     0x60000203
ADDR_LED_7_0                EQU     0x60000100
ADDR_LED_15_8               EQU     0x60000101
ADDR_LED_23_16              EQU     0x60000102
ADDR_LED_31_24              EQU     0x60000103
ADDR_BUTTONS                EQU     0x60000210

BITMASK_KEY_T0              EQU     0x01
BITMASK_LOWER_NIBBLE        EQU     0x0F
	


; ------------------------------------------------------------------
; -- Variables
; ------------------------------------------------------------------
        AREA MyAsmVar, DATA, READWRITE
; STUDENTS: To be programmed
byte_array	SPACE 16	; DCB 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0



; END: To be programmed
        ALIGN

; ------------------------------------------------------------------
; -- myCode
; ------------------------------------------------------------------
        AREA myCode, CODE, READONLY

main    PROC
        EXPORT main

readInput
        BL    waitForKey                    ; wait for key to be pressed and released
; STUDENTS: To be programmed
		LDR  R7,=ADDR_DIP_SWITCH_15_8	;load address of dip switches
		LDRB R1, [R7]					;load byte from the address of r7 in r1
		LDR  R7, =BITMASK_LOWER_NIBBLE	;load bit mask in r7
		ANDS R1, R7						;remove upper nibble
		LDR  R7,=ADDR_LED_15_8			;load address of leds in r7
		STRB R1, [R7]					;store value in address of r7
		
		; 2.
		LDR  R7, =ADDR_DIP_SWITCH_7_0	;load addr of dip switches
		LDRB R0, [R7]					;load byte from the address of r7
		LDR  R7,=ADDR_LED_7_0			;load address of leds in r7
		STRB R0, [R7]					;store byte from r0 in address of r7
		
		;3.
		LDR  R7,=byte_array				;load address of byte_array
		STRB R0,[R7,R1]					;store byte from r0 in byte array

		LDR  R7, =ADDR_DIP_SWITCH_31_24
		LDRB R1, [R7]
		LDR  R7, =BITMASK_LOWER_NIBBLE
		ANDS R1, R7
		LDR  R7, =ADDR_LED_31_24
		STRB R1, [R7]
		
		LDR  R7, =byte_array
		LDRB R0, [R7,R1]
		LDR  R7, =ADDR_LED_23_16
		STRB R0, [R7]

; END: To be programmed
        B       readInput
        ALIGN

; ------------------------------------------------------------------
; Subroutines
; ------------------------------------------------------------------

; wait for key to be pressed and released
waitForKey
        PUSH    {R0, R1, R2}
        LDR     R1, =ADDR_BUTTONS           ; laod base address of keys
        LDR     R2, =BITMASK_KEY_T0         ; load key mask T0

waitForPress
        LDRB    R0, [R1]                    ; load key values
        TST     R0, R2                      ; check, if key T0 is pressed
        BEQ     waitForPress

waitForRelease
        LDRB    R0, [R1]                    ; load key values
        TST     R0, R2                      ; check, if key T0 is released
        BNE     waitForRelease
                
        POP     {R0, R1, R2}
        BX      LR
        ALIGN

; ------------------------------------------------------------------
; End of code
; ------------------------------------------------------------------
        ENDP
        END
