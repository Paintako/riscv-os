# section : this is a symbol that tells the assembler to put the following code in a specific section of the object file. 
# The .text section is where the code goes, and the .rodata section is where read-only data goes.

.section .rodata

# heap is defined in the linker script, which is using "PROVIDE(_heap_start = .);" to define the start of the heap
.global HEAP_START
HEAP_START: .word _heap_start

.global HEAP_SIZE
HEAP_SIZE: .word _heap_size

.global TEXT_START
TEXT_START: .word _text_start

.global TEXT_END
TEXT_END: .word _text_end

.global DATA_START
DATA_START: .word _data_start

.global DATA_END
DATA_END: .word _data_end

.global RODATA_START
RODATA_START: .word _rodata_start

.global RODATA_END
RODATA_END: .word _rodata_end

.global BSS_START
BSS_START: .word _bss_start

.global BSS_END
BSS_END: .word _bss_end
