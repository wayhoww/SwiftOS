
Different ARM boards are configured with different booting strategy.

Currently QEMU Virt 9.0 is used.


in order to use float-point related instructions, the feature has to be enabled.
```
    MRS x30, CPACR_EL1;
    ORR x30, x30, #(3 << 20);
    MSR CPACR_EL1, x30;
```

Theoretically, ARM allows misaligned memory ldr. Though it failed.
Compiling C & Swift code with -mstrict-align addresses the issue.

Swift accept clang args via -Xcc. e.g. -Xcc  -mstrict-align


"-d int,in_asm -D qemu.log" enables QEMU logs.
"-S -s" enables qemu guest code debugging. GDB/LLDB can be attached via tcp 1234/

host (hvf) support is corrupted... skip it for now.


Reference：
https://wiki.osdev.org/QEMU_AArch64_Virt_Bare_Bones
https://lists.nongnu.org/archive/html/qemu-discuss/2015-07/msg00054.html (fpu enabling)
https://stackoverflow.com/questions/75287441/qemu-for-aarch64-why-execution-stucks-at-ldr-q1-x0 (alignment)
https://github.com/qemu/qemu/blob/master/util/log.c (qemu logging option)
