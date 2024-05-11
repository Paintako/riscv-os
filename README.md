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
