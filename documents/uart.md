

Output: write to 0x9000_0000

Read from serial: reading from 0x9000_0000 results in pressed keyboard. But the value won't reset after reading/releasing.

Note that: KEYBOARD AND MONITOR are not involved here. They are simply serial I/O.


> Flash memory starts at address 0x0000_0000
> RAM starts at 0x4000_0000 
> All other information about device locations may change between QEMU versions, so guest code must look in the DTB.


how to read datasheet? look at the programmers-model

reference：
https://github.com/qemu/qemu/blob/master/hw/arm/virt.c
https://qemu-project.gitlab.io/qemu/system/arm/virt.html
https://groups.google.com/a/groups.riscv.org/g/sw-dev/c/1gpj3Z9Aqew (uart is easier. The document is about RISCV)
https://www.perplexity.ai/search/wo-yong-qemu-virtkai-fa-yi-ge-_uBfEky_QSy3nj3mJUUN3w#0 (AI, but works. read from UART0)
https://developer.arm.com/documentation/ddi0183/g/programmers-model/about-the-programmers-model 