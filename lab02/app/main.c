/* -----------------------------------------------------------------
 * --  _____       ______  _____                                    -
 * -- |_   _|     |  ____|/ ____|                                   -
 * --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
 * --   | | | '_ \|  __|  \___ \   Zurich University of             -
 * --  _| |_| | | | |____ ____) |  Applied Sciences                 -
 * -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
 * ------------------------------------------------------------------
 * --
 * -- main.c
 * --
 * -- main for Computer Engineering "Bit Manipulations"
 * --
 * -- $Id: main.c 744 2014-09-24 07:48:46Z ruan $
 * ------------------------------------------------------------------
 */
//#include <reg_ctboard.h>
#include "utils_ctboard.h"

#define ADDR_DIP_SWITCH_31_0 0x60000200
#define ADDR_DIP_SWITCH_7_0  0x60000200
#define ADDR_LED_31_24       0x60000103
#define ADDR_LED_23_16       0x60000102
#define ADDR_LED_15_8        0x60000101
#define ADDR_LED_7_0         0x60000100
#define ADDR_BUTTONS         0x60000210

// define your own macros for bitmasks below (#define)
/// STUDENTS: To be programmed
#define MASK_LED_7_6_ALWAYS_ON 0xC0
#define MASK_LED_5_4_NEVER_ON 0xCF
#define MASK_IGNORE_UPPER_NIBBLE 0x0F

#define MASK_T0 0xFE
#define MASK_T1 0xFD
#define MASK_T2 0xFB
#define MASK_T3 0xF7


/// END: To be programmed

int main(void)
{
    uint8_t led_value = 0;

    // add variables below
    /// STUDENTS: To be programmed
		uint8_t button_value = 0;
		uint8_t button_value_before = 0;
		uint8_t counter = 0;
		uint8_t button_change_detect = 0;
		uint8_t multi_variable = 0;


    /// END: To be programmed

    while (1) {
        // ---------- Task 3.1 ----------
        led_value = read_byte(ADDR_DIP_SWITCH_7_0);

        /// STUDENTS: To be programmed
				led_value |= MASK_LED_7_6_ALWAYS_ON;
				led_value &= MASK_LED_5_4_NEVER_ON;
        /// END: To be programmed

        write_byte(ADDR_LED_7_0, led_value);

        // ---------- Task 3.2 and 3.3 ----------
        /// STUDENTS: To be programmed
				button_value = read_byte(ADDR_BUTTONS);
				button_value &= MASK_IGNORE_UPPER_NIBBLE;
				button_change_detect = (~button_value) & button_value_before;
				
				if((button_change_detect ^ MASK_T0) == 0xFF){
					counter++;
					multi_variable = multi_variable >> 1;
				} else if((button_change_detect ^ MASK_T1) == 0xFF){
					multi_variable = multi_variable << 1;
				} else if((button_change_detect ^ MASK_T2) == 0xFF){
					multi_variable = (~multi_variable);
				} else if((button_change_detect ^ MASK_T3) == 0xFF){
					multi_variable = read_byte(ADDR_DIP_SWITCH_7_0);
				}
				button_value_before = button_value;
				write_byte(ADDR_LED_15_8, counter);
				write_byte(ADDR_LED_23_16, multi_variable);

        /// END: To be programmed
    }
}
