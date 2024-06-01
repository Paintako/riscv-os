#ifndef __UART_H__
#define __UART_H__

void uart_init();
int uart_putc(char ch);
void uart_puts(char *s);

#endif