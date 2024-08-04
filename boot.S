
# set stack size
.set STACK_SIZE, 0x1000 # 0001 0000 0000 0000, 2^12 = 4096 bytes
.section .text.init
.global _start

# using HART ID register to determine which hart is running
_start:
    csrr t0, mhartid # load hart id
    la sp, stack0
    li t1, STACK_SIZE
    addi t0, t0, 1
    mul t0, t0, t1
    add sp, sp, t0
    j main


# loop forever
_park:
    wfi # wait for interrupt
