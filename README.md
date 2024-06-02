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

## RVOS
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
The linker script is stored in the file `linker.ld`.
By define the memory layout in the linker script, we can control where the code and data are placed in memory.
We can use the memory more efficiently by utilizing linker, and accomplish function such as memory protection or malloc.

