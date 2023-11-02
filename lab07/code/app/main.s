;* ------------------------------------------------------------------
;* --  _____       ______  _____                                    -
;* -- |_   _|     |  ____|/ ____|                                   -
;* --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
;* --   | | | '_ \|  __|  \___ \   Zurich University of             -
;* --  _| |_| | | | |____ ____) |  Applied Sciences                 -
;* -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
;* ------------------------------------------------------------------
;* --
;* -- Project     : CT1 - Lab 7
;* -- Description : Control structures
;* -- 
;* -- $Id: main.s 3748 2016-10-31 13:26:44Z kesr $
;* ------------------------------------------------------------------


; -------------------------------------------------------------------
; -- Constants
; -------------------------------------------------------------------
    
                AREA myCode, CODE, READONLY
                    
                THUMB

ADDR_LED_15_0           EQU     0x60000100
ADDR_LED_31_16          EQU     0x60000102
ADDR_7_SEG_BIN_DS1_0    EQU     0x60000114
ADDR_DIP_SWITCH_15_0    EQU     0x60000200
ADDR_HEX_SWITCH         EQU     0x60000211
	
MASK_REMOVE_31_16		EQU		0x000F

NR_CASES                EQU     0xB

jump_table      ; ordered table containing the labels of all cases
                ; STUDENTS: To be programmed 
						DCD		case_dark	;0
						DCD		case_add	;1
						DCD		case_sub	;2
						DCD		case_mul	;3
						DCD		case_and	;4
						DCD		case_or		;5
						DCD		case_xor	;6
						DCD		case_not	;7
						DCD		case_nand	;8
						DCD		case_nor	;9
						DCD		case_xnor	;A
						DCD		case_bright	;B
                ; END: To be programmed
    

; -------------------------------------------------------------------
; -- Main
; -------------------------------------------------------------------   
                        
main            PROC
                EXPORT main
                
read_dipsw      ; Read operands into R0 and R1 and display on LEDs
                ; STUDENTS: To be programmed
				LDR		R7,=ADDR_DIP_SWITCH_15_0	;load address of dip switches
				LDRB	R0, [R7]					;store left operand in r0
				LDRH	R1, [R7]					;store left and right operand in r1
				LDR		R7, =ADDR_LED_15_0			;load address of leds
				STRH	R1, [R7]					;display left and right operand in leds
				LSRS	R1, #8						;remove left operand
				
				;LSLS	R0, #24
				;LSLS	R1, #24
				
                ; END: To be programmed
                    
read_hexsw      ; Read operation into R2 and display on 7seg.
                ; STUDENTS: To be programmed
				LDR		R7, =ADDR_HEX_SWITCH		;load address of hex switch
				LDRB	R2, [R7]					;read value of hex; R2 -> mode index
				LDR		R3, =MASK_REMOVE_31_16		;load mask to remove upper 1's
				ANDS	R2, R3						;remove upper 1's
				LDR		R7, =ADDR_7_SEG_BIN_DS1_0	;load address of 7seg
				STR		R2,	[R7]					;display mode index in 7seg
                ; END: To be programmed
                
case_switch     ; Implement switch statement as shown on lecture slide
                ; STUDENTS: To be programmed
				CMP		R2, #NR_CASES				;check if higher than available cases
				BHS		case_bright					;go to defaul case (bright) if so
				LSLS	R2, #2						;multiply by 4 (DCD = 4 byte)
				LDR		R7, =jump_table				;load address of jump table
				LDR		R7, [R7, R2]				;get label with index offset
				BX		R7							;goto selected label
                ; END: To be programmed


; Add the code for the individual cases below
; - operand 1 in R0
; - operand 2 in R1
; - result in R0

; STUDENTS: To be programmed

case_dark       
                LDR		R0, =0
                B		display_result  

case_add        
                ADDS 	R0, R0, R1
                B    	display_result

case_sub		SUBS	R0, R0, R1
				B		display_result

case_mul		MULS	R0, R1, R0
				B		display_result

case_and		ANDS	R0, R0, R1
				B		display_result

case_or			ORRS		R0, R0, R1
				B		display_result

case_xor		EORS	R0, R0, R1
				B		display_result

case_not		MVNS	R0, R0
				B		display_result

case_nand		ANDS	R0, R0, R1
				MVNS	R0, R0
				B		display_result

case_nor		ORRS	R0, R0, R1
				MVNS	R0, R0
				B		display_result

case_xnor		EORS	R0, R0, R1
				MVNS	R0, R0
				B		display_result

case_bright		LDR		R0, =0xFFFF
				B		display_result

; END: To be programmed


display_result  ; Display result on LEDs
                ; STUDENTS: To be programmed
				LDR		R7, =ADDR_LED_31_16				;load address of leds
				STR		R0,	[R7]						;display result with leds
                ; END: To be programmed

                B    read_dipsw
                
                ALIGN
                ENDP

; -------------------------------------------------------------------
; -- End of file
; -------------------------------------------------------------------                      
                END

