;* ------------------------------------------------------------------
;* --  _____       ______  _____                                    -
;* -- |_   _|     |  ____|/ ____|                                   -
;* --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
;* --   | | | '_ \|  __|  \___ \   Zurich University of             -
;* --  _| |_| | | | |____ ____) |  Applied Sciences                 -
;* -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
;* ------------------------------------------------------------------
;* --
;* -- Project     : CT1 - Lab 10
;* -- Description : Search Max
;* -- 
;* -- $Id: search_max.s 879 2014-10-24 09:00:00Z muln $
;* ------------------------------------------------------------------


; -------------------------------------------------------------------
; -- Constants
; -------------------------------------------------------------------
                AREA myCode, CODE, READONLY
                THUMB
                    
; STUDENTS: To be programmed
lowest_32_bit	EQU		0x80000000



; END: To be programmed
; -------------------------------------------------------------------                    
; Searchmax
; - tableaddress in R0
; - table length in R1
; - result returned in R0
; -------------------------------------------------------------------   
search_max      PROC
                EXPORT search_max

                ; STUDENTS: To be programmed
				PUSH {R4-R7, LR}
				MOVS	R4,R0				;get the table address
				LDR		R0,=lowest_32_bit	;get lowest value into return
				MOVS	R5,#0				;R5 = i = 0
				MOVS	R6,#0				;R6 = offset (i * 4)
for_loop
				CMP		R5,R1
				BHS		end_for
				ADDS	R5,#1				;i++
				
				LDR		R7,[R4,R6]			;R7 = table entry to compare
				LSLS	R6,R5,#2			;update offset for next loop
				CMP		R7,R0				;check if table entry is bigger
				BLE		for_loop			;continue if lower or same
				MOVS	R0,R7				;replace if higher value found
				B		for_loop			;continue for loop
end_for				
				POP {R4-R7, PC}
                ; END: To be programmed
                ALIGN
                ENDP
; -------------------------------------------------------------------
; -- End of file
; -------------------------------------------------------------------                      
                END

