#include <stdint.h>
#include <stddef.h>

#include "volatile.h"

int putchar(int c) {
    volatile int* uart = (int*)0x09000000;
    return *uart = c;
}

int posix_memalign(void **memptr, size_t alignment, size_t size) {
    static uint8_t memory_chunk[1024 * 1024 * 1];
    static size_t memory_chunk_offset = 0;

    size_t aligned_offset = (memory_chunk_offset + alignment - 1) & ~(alignment - 1);
    if (aligned_offset + size > sizeof(memory_chunk)) {
        undefined(); // TODO
        return -1;
    }

    *memptr = &memory_chunk[aligned_offset];
    memory_chunk_offset = aligned_offset + size;

    return 0;
}

void *memmove(void *dest, const void *src, size_t n) {
    char *d = dest;
    const char *s = src;
    if (d < s) {
        while (n--) {
            *d++ = *s++;
        }
    } else {
        d += n;
        s += n;
        while (n--) {
            *--d = *--s;
        }
    }
    return dest;
}

void *memcpy(void *dest, const void *src, size_t n) {
    return memmove(dest, src, n);
}

void *memset(void *s, int c, size_t n) {
    char *p = s;
    while (n--) {
        *p++ = c;
    }
    return s;
}

void free(void *ptr) {}
