# qemu commands for emulating FreeBSD on Debian

Chapter 24 from the FreeBSD book helped me set up the virtual machine.

https://docs.freebsd.org/en/books/handbook/virtualization/

See the man page for qemu Intel version

	man qemu-system-x86_64

This command creates a 16 gigabyte disk image to use. I chose this size to be sure to have enough space to run anything I desire on the emulated FreeBSD system. 

	qemu-img create -f raw FreeBSD-amd64.img 16G

I took the example script from chapter 24 and modified it until it worked for what I was doing.

```
qemu-system-x86_64  -monitor none \
  -cpu qemu64 \
  -vga std \
  -m 4096 \
  -smp 4   \
  -cdrom FreeBSD-15.0-RELEASE-amd64-dvd1.iso \
  -boot order=cd,menu=on \
  -blockdev driver=file,aio=threads,node-name=imgleft,filename=FreeBSD-amd64.img \
  -blockdev driver=raw,node-name=drive0,file=imgleft \
  -device virtio-blk-pci,drive=drive0,bootindex=1  \
  -name \"FreeBSD\"
```

Once emulating, Ctrl+Alt+G removes the window's grab on the keyboard and mouse.

The emulation was successful. I booted from the .iso installation for FreeBSD and installed it to the 16 GB disk that was created. After the installation, I rebooted and then it automatically new to boot from the disk rather than the ISO this time.

This means that for the first time, I am able to run a successful emulator in qemu. This has potential for me to learn the Assembly language of other operating systems or even other CPU types if I learn how to emulate them.
