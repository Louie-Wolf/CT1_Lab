#include "utils_ctboard.h"

#define LED_ADDR 0x60000100
#define SWITCH_ADDR 0x60000200
#define ROTARY_ADDR 0x60000211
#define DISPLAY_ADDR 0x60000110
#define MASK 0x0F

#define CALC_MASK 0xFFFFFF00

int main(void)
{
	uint32_t switchValue;
	uint8_t rotaryValue;
	const uint8_t patterns[16] = {0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8,0x80, 0x98, 0x88, 0x83, 0xC6, 0xA1, 0x86, 0x8E};
	
	
	while(1){
		switchValue = read_word(SWITCH_ADDR);
		write_word(LED_ADDR, switchValue);
		
		if((CALC_MASK | switchValue) == 0xFFFFFFFF){
			write_byte(0x60000110, patterns[11]);
			write_byte(0x60000111, patterns[0]);
			write_byte(0x60000112, patterns[0]);
			write_byte(0x60000113, patterns[11]);
		} else {
			rotaryValue = read_byte(ROTARY_ADDR);
			rotaryValue = rotaryValue & MASK;
			write_byte(DISPLAY_ADDR, patterns[rotaryValue]);
			write_byte(0x60000111, 0xFF);
			write_byte(0x60000112, 0xFF);
			write_byte(0x60000113, 0xFF);
		}
		
		
	}
}
