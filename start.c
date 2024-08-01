#include "platform.h"
// #include "printf.h"
// #include "uart.h"

// extern: By reference C99
// extern void malloc(int num_pages);

char stack0[4086 * NCPU];  // 8 * 4086 = 32688, define stack for 8 CPUs

int main() {
	// uart_init();
	// uart_puts("Hello, OS kernel!\n");
	// uart_puts("Malloc test\n");
	// printf("printf test\n");
	// malloc(1);
	return 0;
}