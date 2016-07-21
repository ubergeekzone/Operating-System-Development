
# zimOS barebones for Amy =)

# for building the floppy image automatically
FLPDIR=flp.dir
GRUBDIR=$(shell dirname `find /lib/grub/i386-pc/ /boot -name fat_stage1_5 |head -n 1 2> /dev/null`)

# settings for compiler, so it doesn't include system cruft
CFLAGS=-ffreestanding -nostdlib -nostartfiles -nostdinc -nodefaultlibs -fno-builtins

# source files to build .. loader.o should always be first (GRUB requirement of the kernel for linking)
OBJS=loader.o kernel.o

# what to build by default (floppy.img, and make sure changes to Makefile force a rebuild)
all: Makefile floppy.img

# build our kernel (strips, no shared libraries, load kernel at 1MB, loader is entry point)
kernel.elf: $(OBJS)
	ld -s -static -nostdlib -Ttext 0x1000000 -e loader -o $@ $+

# create bootable floppy image
floppy.img: kernel.elf
	dd if=/dev/zero of=floppy.img count=1 seek=1439 bs=1024
	mkdosfs $@
	(mkdir $(FLPDIR) &&	sudo mount -o loop,uid=$(USER) $@ $(FLPDIR)) || true
	mkdir -p $(FLPDIR)/grub
	cp ./grub/menu.lst  $(GRUBDIR)/stage1 ./stage2 $(GRUBDIR)/fat_stage1_5 kernel.elf $(FLPDIR)/grub
	sudo umount $(FLPDIR)
	grub --batch --no-floppy --no-curses < ./grub/install 2>&1 /dev/null
	rm -fR $(FLPDIR)

# clean out all object files, and the created kernel
clean:
	rm -f kernel.elf *.o
