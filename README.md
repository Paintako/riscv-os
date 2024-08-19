# Building Ubuntu for developing experimental environment

## Docker configuration
### Build image
`docker build -t linux_latest .`

* NOTE: -t gives a tag/name to your image

### Running container
`docker run -it --name os -v $PWD/work:/work linux_latest`
* Container Volumes: 
    * Volumes provide the ability to connect specific filesystem paths of the container back to the host machine.
    * -t: attach時Container的螢幕會接到原來的螢幕上
    * -i: Container stays interactive
    * -v: volume, `absolute path which you want to mount local folder into container`: `container folder you want to mount with`

### Restart container
`docker restart os`

### Attach to container
`docker attach os`
* Note: Before attach you must restart or run container

## Risc-V OS requirements
To use GNU toolchain and QEMU emulator, execute the following lines.
```bash
$ sudo apt update
$ sudo apt install build-essential gcc make perl dkms git gcc-riscv64-unknown-elf gdb-multiarch qemu-system-misc
```

## QEMU for RISC-V
We could use QEMU to emulate RISC-V architecture. And also using GDB to debug the code.
To run the QEMU, we need to use the following command.
```bash
make run
```

## RVOS
### Basic Initialization
When a program is loaded, it requires:
1. All it’s data is presented at correct memory address.
2. The program counter is set to correct memory address.
3. The bss segment are initialized to 0.
4. The stack pointer is set to a proper address.

### bootloader
Before we start running our OS, we need to write a bootloader. 
The bootloader is the first thing that runs when the computer is turned on. 
It is responsible for loading the OS into memory and starting it. 
The bootloader is stored in the first sector of the disk, which is 512 bytes long. 
The bootloader is written in assembly and is very simple. It reads the OS from the disk and jumps to it. 
The OS is stored in the second sector of the disk. The bootloader is stored in the file `boot.S`.

We need to do the following steps to write the bootloader:
1. Set up stack pointer for each CPU core.
2. Load the OS from the disk into memory.
3. Jump to the OS, which is stored in the second sector of the disk, and usually written in C. Note that in qemu, kernel is loaded at 0x80000000, qemu expects the kernel to be loaded at this address.

### Memory management
Using linker script to manage memory layout.
By define the memory layout in the linker script, we can control where the code and data are placed in memory.
We can use the memory more efficiently by utilizing linker, and accomplish function such as memory protection or malloc.

We can use `PROVIDE` to define a symbol in the linker script, which can be access in the C code.
For example, the following linker script defines a symbol `_memory_start` at the start of the memory.
```ld
PROVIDE(_memory_start = ORIGIN(ram));
```
`ORIGIN` is a built-in function that returns the starting address of the memory region.

Note that we should define the symbol in a wright data type, such as `.word` for 32-bit integer, `.byte` for 8-bit integer, etc.
Because our system is a 64-bit system, we should use `.quad` for 64-bit integer. Otherwise the memory address will be wrong.

We use a struct to define each byte in the HEAP is used or not.
```c
struct page {
    uint8 flags;
}
```

To implement the described memory allocation and deallocation scheme, you can follow these steps:
1. Memory Allocation:
* When allocating memory, mark the flags of the allocated bytes as 01.
* Ensure that the last byte of the allocated memory block is marked with 11 to indicate the end of the allocation.

2. Memory Deallocation:
* When freeing memory, check the flags of the memory block.
* Traverse through the allocated bytes and look for a byte with the 11 flag.
* Once you reach a byte with the 11 flag, free the entire block, knowing that this marks the end of the allocated region.

## Format
### clang-format
```bash
clang-format -i *[.ch]
```
*[.ch] means all files with .c and .h extension.
`-i` means in-place, which means the file will be modified in place.
