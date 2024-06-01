#ifndef __PLATFORM_H__
#define __PLATFORM_H__
/*
 * This file is used to define the platform-specific configurations.
 * Refer to the qemu virt.c to see how the platform is defined.
 */

#define NCPU 8 // Maximum number of CPUs

#define UART_BASE 0x10000000 // UART base address

#endif // __PLATFORM_H__