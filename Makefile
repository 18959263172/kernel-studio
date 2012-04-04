run: kernel.img rootfs.img
	qemu-system-x86_64 -kernel kernel.img -append "root=/dev/ram rdinit=/sbin/init" -initrd rootfs.img

debug: kernel.img rootfs.img
	qemu-system-x86_64 -kernel kernel.img -append "root=/dev/ram rdinit=/sbin/init kgdboc=ttyS0,115200 kgdbwait" -initrd rootfs.img -serial tcp::1234,server &
	gdb linux/vmlinux

install: linux/.config busybox/.config
	./install

kernel.img: linux/arch/x86/boot/bzImage 
	make -C linux bzImage -j4
	cp linux/arch/x86/boot/bzImage kernel.img

rootfs.img: busybox/_install/bin/busybox
	make -C busybox install -j4
	./mkrootfs

.PHONY: run debug install
