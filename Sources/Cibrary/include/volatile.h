#include <stdint.h>
#include <stddef.h>

uint64_t get_current_el();

void write_volatile_u32(uint32_t* addr, uint32_t value);
uint32_t read_volatile_u32(const uint32_t* addr);

uint32_t read_volatile_u32_size_t(size_t addr);

void enable_interrupts();

void undefined();
