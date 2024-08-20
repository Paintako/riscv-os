#ifndef _RISCV_H__
#define _RISCV_H__
#include "types.h"

#define reg_t uint64_t  // RISCV64: register is 64bits

// Follow RISC-V calling convention, we should save the following registers
struct context {
	reg_t ra;  // x1
	reg_t sp;  // x2, stack pointer

	// callee-saved registers
	reg_t s0;   // x8
	reg_t s1;   // x9
	reg_t s2;   // x18
	reg_t s3;   // x19
	reg_t s4;   // x20
	reg_t s5;   // x21
	reg_t s6;   // x22
	reg_t s7;   // x23
	reg_t s8;   // x24
	reg_t s9;   // x25
	reg_t s10;  // x26
	reg_t s11;  // x27
};


#endif
