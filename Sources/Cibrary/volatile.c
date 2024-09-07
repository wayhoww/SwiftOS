#include "volatile.h"

void write_volatile_u32(uint32_t* addr, uint32_t value) {
    volatile uint32_t* volatile_addr = addr;
    *volatile_addr = value;
}

uint32_t read_volatile_u32(const uint32_t* addr) {
    const volatile uint32_t* volatile_addr = addr;
    return *volatile_addr;
}

void enable_interrupts() {
    //aarch64 assembly
    asm volatile("msr daifclr, #2");

    // // enable irq and fiq
    asm volatile(
        "MRS x30, DAIF;\t\n"
        "AND x30, x30, #(~(1 << 7));\t\n"
        "AND x30, x30, #(~(1 << 6));\t\n"
        "MSR DAIF, x30;\t\n"
    );

}


uint32_t read_volatile_u32_size_t(size_t addr) {
    return read_volatile_u32((const uint32_t*)addr);
}

uint64_t get_current_el() {
    uint64_t el;
    asm volatile("mrs %0, CurrentEL" : "=r"(el));
    return el;
}

void undefined() {
    asm volatile("udf #0");
}

