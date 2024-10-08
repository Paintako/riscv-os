# Write by: Paintakotako

# Make file rules:
# $@ : 該規則的目標文件 (Target file)
# $* : 代表 targets 所指定的檔案，但不包含副檔名
# $< : 依賴文件列表中的第一個依賴文件 (Dependencies file)
# $^ : 依賴文件列表中的所有依賴文件，也就是冒號右邊的部分
# $? : 依賴文件列表中新於目標文件的文件列表
# $* : 代表 targets 所指定的檔案，但不包含副檔名

# ?= 語法 : 若變數未定義，則替它指定新的值。
# := 語法 : make 會將整個 Makefile 展開後，再決定變數的值。
CC = riscv64-unknown-elf-gcc
AS = riscv64-unknown-elf-as
LD = riscv64-unknown-elf-ld
CFLAGS = -nostdlib -nostartfiles -fno-builtin -g -Wall -march=rv64g -mabi=lp64d -mcmodel=medany

cfiles = $(wildcard *.c)
asfiles = $(wildcard *.S)
ofiles = $(patsubst %.c, out/%.o, $(cfiles))
ofiles += $(patsubst %.S, out/%.o, $(asfiles))

# 檢查並創建 out 資料夾
out:
	mkdir -p out

run: out/kernel.elf
	echo "Press Ctrl-A and then X to exit QEMU"
	qemu-system-riscv64 -nographic -machine virt -cpu rv64 -m 128M -bios none -s -kernel out/kernel.elf

debug: out/kernel.elf
	echo "Press Ctrl-A and then X to exit QEMU"
	qemu-system-riscv64 -nographic -machine virt -cpu rv64 -m 128M -bios none -s -S -kernel out/kernel.elf

all: out $(ofiles) out/kernel.elf

out/kernel.elf: $(ofiles)
	$(LD) -T linker.ld -o $@ $^ -Map out/kernel.map

# compile all c files
out/%.o: %.c | out
	$(CC) $(CFLAGS) -c -o $@ $<

# compile all assembly files
out/%.o: %.S | out
	$(AS) -o $@ $<

objdump: out/kernel.elf
	@echo "Disassemble kernel.elf"
	riscv64-unknown-elf-objdump -dS out/kernel.elf > out/kernel.dump

.PHONY : clean
clean:
	rm -f out/*.o out/*.elf out/*.map out/*.dump
