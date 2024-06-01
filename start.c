#include "platform.h"
#include "uart.h"

char stack0[4086 * NCPU]; // 8 * 4086 = 32688, define stack for 8 CPUs

int main()
{
    uart_init();
    uart_puts("Hello, OS kernel!\n");
    return 0;
}