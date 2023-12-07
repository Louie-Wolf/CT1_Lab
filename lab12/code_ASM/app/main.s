;* ----------------------------------------------------------------------------
;* --  _____       ______  _____                                              -
;* -- |_   _|     |  ____|/ ____|                                             -
;* --   | |  _ __ | |__  | (___    Institute of Embedded Systems              -
;* --   | | | '_ \|  __|  \___ \   Zurich University of                       -
;* --  _| |_| | | | |____ ____) |  Applied Sciences                           -
;* -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland               -
;* ----------------------------------------------------------------------------
;* --
;* -- Project     : CT1 - Lab 12
;* -- Description : Reading the User-Button as Interrupt source
;* -- 				 
;* -- $Id: main.s 5082 2020-05-14 13:56:07Z akdi $
;* -- 		
;* ----------------------------------------------------------------------------


                IMPORT init_measurement
                IMPORT clear_IRQ_EXTI0
                IMPORT clear_IRQ_TIM2

; -----------------------------------------------------------------------------
; -- Constants
; -----------------------------------------------------------------------------

                AREA myCode, CODE, READONLY

                THUMB

REG_GPIOA_IDR       EQU  0x40020010
LED_15_0            EQU  0x60000100
LED_16_31           EQU  0x60000102
REG_CT_7SEG         EQU  0x60000114
REG_SETENA0         EQU  0xe000e100


; -----------------------------------------------------------------------------
; -- Main
; -----------------------------------------------------------------------------             
main            PROC
                EXPORT main


                BL   init_measurement    

                ; Configure NVIC (enable interrupt channel)
                ; STUDENTS: To be programmed
				LDR 	R0,=REG_SETENA0
				LDR 	R1,[R0]
                ; END: To be programmed 

                ; Initialize variables
                ; STUDENTS: To be programmed	
				LDR 	R2, =0x10000040
				ORRS 	R1,R2			;make sure I dont overwrite the others
				STR 	R1,[R0]

                ; END: To be programmed

loop
                ; Output counter on 7-seg
                ; STUDENTS: To be programmed
				LDR  	R0, =REG_CT_7SEG
                LDR 	R1, =counter_per_interval
                LDR 	R1, [R1]
                STRH 	R1, [R0]

                ; END: To be programmed

                B    loop

                ENDP

; -----------------------------------------------------------------------------
; Handler for EXTI0 interrupt
; -----------------------------------------------------------------------------
                 ; STUDENTS: To be programmed
EXTI0_IRQHandler	PROC
					EXPORT EXTI0_IRQHandler
					PUSH 	{LR}
					
					LDR		R0, =counter
					LDR		R1,[R0]
					ADDS	R1,#1
					STR		R1,[R0]
					
					BL 		clear_IRQ_EXTI0
					
					POP		{PC}
					ENDP
                 ; END: To be programmed

 
; -----------------------------------------------------------------------------                   
; Handler for TIM2 interrupt
; -----------------------------------------------------------------------------
                ; STUDENTS: To be programmed
TIM2_IRQHandler		PROC
					EXPORT TIM2_IRQHandler
					PUSH 	{LR}
					LDR 	R0,=LED_16_31
					LDR		R1,[R0]
					LDR		R2,=0x0000FFFF
					EORS	R1,R2
					STRH	R1,[R0]
					
					LDR		R0,=counter
					LDR		R1,[R0]
					LDR		R2,=counter_per_interval
					STR		R1,[R2]
					MOVS	R1,#0
					STR		R1,[R0]
					
					BL 		clear_IRQ_TIM2
					
					POP		{PC}
					ENDP
                ; END: To be programmed
                ALIGN

; -----------------------------------------------------------------------------
; -- Variables
; -----------------------------------------------------------------------------

                AREA myVars, DATA, READWRITE

                ; STUDENTS: To be programmed
counter					DCD 0
counter_per_interval	DCD 0

                ; END: To be programmed


; -----------------------------------------------------------------------------
; -- End of file
; -----------------------------------------------------------------------------
                END
