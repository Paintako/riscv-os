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

/* PHDRS: Define the program headers */

/* 
    #define PT_LOAD         1               Loadable program segment 
    #define PT_DYNAMIC      2               Dynamic linking information
    #define PT_INTERP       3               Program interpreter
    #define PT_PHDR         6               Entry for header table itself
 */

PHDRS
{
  text PT_LOAD;
  data PT_LOAD;
  bss PT_LOAD;
}


SECTIONS
{
  .text : {
    PROVIDE(_text_start = .);
    *(.text.init) *(.text .text.*)
    PROVIDE(_text_end = .);
  } >ram AT>ram :text

   PROVIDE(_global_pointer = .);

  .rodata : {
    PROVIDE(_rodata_start = .);
    *(.rodata .rodata.*)
    PROVIDE(_rodata_end = .);
  } >ram AT>ram :text

  .data : {
    . = ALIGN(4096);
    PROVIDE(_data_start = .);
    *(.sdata .sdata.*) *(.data .data.*)
    PROVIDE(_data_end = .);
  } >ram AT>ram :data

  .bss : {
    PROVIDE(_bss_start = .);
    *(.sbss .sbss.*) *(.bss .bss.*)
    PROVIDE(_bss_end = .);
  } >ram AT>ram :bss


  PROVIDE(_memory_start = ORIGIN(ram));
}