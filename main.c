
#include <util/delay.h>
#include <avr/io.h>
#include <avr/sleep.h>
#include <avr/wdt.h>

#define IVL1 2
#define IVL2 3
#define IVL3 5
#define IVL4 7

int main(void) {
    MCUSR = 0;
    wdt_disable();
    PORTA |= 0x80; /* button */
    _delay_us(1);
    if (!(PINA&0x80)) { /* not pressed */
        DDRB |= 0x04; /* LED */
        PORTB |= 0x04; /* LED */

        PORTA |= 0x0F; /* cable */

        int min = 0;
        while (23) {
            for (uint8_t i=0; i<60; i++)
                _delay_ms(1000);
            min++;

            if ((!(PINA&0x01)) && (min == IVL1))
                break;
            if ((!(PINA&0x02)) && (min == IVL2))
                break;
            if ((!(PINA&0x04)) && (min == IVL3))
                break;
            if ((!(PINA&0x08)) && (min == IVL4))
                break;
        }
        for (uint8_t j=0; j<10; j++) {
            PORTB ^= 0x04;
            _delay_ms(100);
        }
    }
    wdt_enable(WDTO_120MS);
    set_sleep_mode(SLEEP_MODE_PWR_DOWN);
    sleep_mode();
}

