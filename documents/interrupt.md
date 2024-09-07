ARM64 provide four levels of EL: EL0-3. EL0 is user-level.

QEMU starts at EL1 by default.

Theoretically, the handling EL of EL1 interrupts shall be set on EL2/3. 
Though EL1 interrupts are indeed routed automatically to EL1. Feature of QEMU/ARM64?


How to jump between ELs:
to lower level: eret
to higher level: interrupt


Location of interrupt table is customizable.

Other thing to consider:
* masking
* nesting
* using the same stack or not
* stack protection (+ calling convention)


reference：
* https://krinkinmu.github.io/2021/01/04/aarch64-exception-levels.html 和同系列文章