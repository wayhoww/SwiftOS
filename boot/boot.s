.global _start
.extern stack_top
.section ".text.boot"
_start:
    MRS x30, CPACR_EL1;
    ORR x30, x30, #(3 << 20);
    MSR CPACR_EL1, x30;

    adr x30, vector_table
    msr VBAR_EL1, x30

    ldr x30, =el1_stack_top
    mov sp, x30

    // adr x30, in_el0
    // msr ELR_EL1, x30

    // mov x30, xzr
    // msr SPSR_EL1, x30

    // eret


in_el0:
    ldr x30, =el0_stack_top
    mov sp, x30

    bl kmain
    b .

.text
.global vector_table
.balign 2048
vector_table:
// part 1
.balign 0x80
    mov x30, #0xd0;
    b exception_entry
.balign 0x80
    mov x30, #0xd1;
    b exception_entry
.balign 0x80
    mov x30, #0xd2;
    b exception_entry
.balign 0x80
    mov x30, #0xd3;
    b exception_entry 
// part 2
.balign 0x80
    mov x30, #0xd4;
    b exception_entry
.balign 0x80
    mov x30, #0xd5;
    b exception_entry
.balign 0x80
    mov x30, #0xd6;
    b exception_entry
.balign 0x80
    mov x30, #0xd7;
    b exception_entry 
// part 3
.balign 0x80
    mov x30, #0xd8;
    b exception_entry
.balign 0x80
    mov x30, #0xd9;
    b exception_entry
.balign 0x80
    mov x30, #0xda;
    b exception_entry
.balign 0x80
    mov x30, #0xdb;
    b exception_entry 
// part 4
.balign 0x80
    mov x30, #0xdc;
    b exception_entry
.balign 0x80
    mov x30, #0xdd;
    b exception_entry
.balign 0x80
    mov x30, #0xde;
    b exception_entry
.balign 0x80
    mov x30, #0xdf;
    b exception_entry 


exception_entry:
    sub sp, sp, #192
    stp x0, x1, [sp, #0]
    stp x2, x3, [sp, #16]
    stp x4, x5, [sp, #32]
    stp x6, x7, [sp, #48]
    stp x8, x9, [sp, #64]
    stp x10, x11, [sp, #80]
    stp x12, x13, [sp, #96]
    stp x14, x15, [sp, #112]
    stp x16, x17, [sp, #128]
    stp x18, x29, [sp, #144]
    stp x30, xzr, [sp, #160]

    mrs x0, ESR_EL1
    mrs x1, FAR_EL1
    mov x2, x30;

    // why is this needed?
    // stp x0, x1, [sp, #176]

    // mov x0, sp
    bl irq_handler

    ldp x0, x1, [sp, #0]
    ldp x2, x3, [sp, #16]
    ldp x4, x5, [sp, #32]
    ldp x6, x7, [sp, #48]
    ldp x8, x9, [sp, #64]
    ldp x10, x11, [sp, #80]
    ldp x12, x13, [sp, #96]
    ldp x14, x15, [sp, #112]
    ldp x16, x17, [sp, #128]
    ldp x18, x29, [sp, #144]
    ldp x30, xzr, [sp, #160]
    add sp, sp, #192
    eret
