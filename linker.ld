/* Refer to the following link for more information on the linker script
   https://ftp.gnu.org/old-gnu/Manuals/ld-2.9.1/html_node/ld_toc.html
*/

/* OUTPUT_ARCH: Specify a particular output machine architecture */
OUTPUT_ARCH( "riscv" )
/* defining the first executable instruction in an output file (its entry point) */
ENTRY( _start )

/* MEMORY: Define the memory layout of the target system */
/* ORIGIN: The starting address of the memory region */
MEMORY
{
  ram  (wxa) : ORIGIN = 0x80000000, LENGTH = 128M
}

SECTIONS
{
  .text : {
    PROVIDE(_text_start = .);
    *(.text.init) 
    *(.text .text.*)
    PROVIDE(_text_end = .);
  } >ram 
  
  .rodata : {
    PROVIDE(_rodata_start = .);
    *(.rodata .rodata.*)
    PROVIDE(_rodata_end = .);
  } >ram 

  .data : {
    . = ALIGN(4096);
    PROVIDE(_data_start = .);
    *(.sdata .sdata.*) *(.data .data.*)
    PROVIDE(_data_end = .);
  } >ram

  .bss : {
    PROVIDE(_bss_start = .);
    *(.sbss .sbss.*) *(.bss .bss.*)
    PROVIDE(_bss_end = .);
  } >ram 


  PROVIDE(_memory_start = ORIGIN(ram));
  PROVIDE(_memory_end = ORIGIN(ram) + LENGTH(ram));

  PROVIDE(_heap_start = _bss_end);
  PROVIDE(_heap_size = _memory_end - _heap_start);
}