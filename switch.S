# Note that we're using 64 bit machine, we should use `ld`, `sd` instead of `lw`, `sw`
# Follow the https://github.com/riscv-non-isa/riscv-asm-manual/blob/main/riscv-asm.md calling convention to store the registers

.macro SAVE_REG base
    sd ra, 0*8(\base)
    sd sp, 1*8(\base)
    sd s0, 2*8(\base)
    sd s1, 3*8(\base)
    sd s2, 4*8(\base)
    sd s3, 5*8(\base)
    sd s4, 6*8(\base)
    sd s5, 7*8(\base)
    sd s6, 8*8(\base)
    sd s7, 9*8(\base)
    sd s8, 10*8(\base)
    sd s9, 11*8(\base)
    sd s10, 12*8(\base)
    sd s11, 13*8(\base)
.endm

.macro LOAD_REG base
    ld ra, 0*8(\base)
    ld sp, 1*8(\base)
    ld s0, 2*8(\base)
    ld s1, 3*8(\base)
    ld s2, 4*8(\base)
    ld s3, 5*8(\base)
    ld s4, 6*8(\base)
    ld s5, 7*8(\base)
    ld s6, 8*8(\base)
    ld s7, 9*8(\base)
    ld s8, 10*8(\base)
    ld s9, 11*8(\base)
    ld s10, 12*8(\base)
    ld s11, 13*8(\base)
.endm


.text
# void switch(struct context *old, struct context *new)
.global switch_context
switch_context:
    SAVE_REG a0
    LOAD_REG a1
    # After loading new context, ra is also loaded, so when we return, we will return to the new context
    ret