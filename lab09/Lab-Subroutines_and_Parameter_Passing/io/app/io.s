				AREA myCode, CODE, READONLY
                
				THUMB 
 
out_word		PROC 			;void out_word(uint32_t out_address, uint32_t out_value);
				EXPORT out_word
				
				STR 	R1,[R0]
				BX		LR
				
				ENDP
					
in_word			PROC			;uint32_t in_word(uint32_t in_address);
				EXPORT in_word
					
				LDR 	R0, [R0]
				BX		LR
				ENDP

				ALIGN 
                END
