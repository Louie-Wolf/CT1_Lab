#include <stdint.h>

#define ADDR_LED 0x60000100
#define ADDR_DIPSW 0x60000200

extern void out_word(uint32_t out_address, uint32_t out_value);
extern uint32_t in_word(uint32_t in_address);

int main(void){
	while(1){
		uint32_t dip = in_word(ADDR_DIPSW);
		out_word(ADDR_LED, dip);
	}
}
