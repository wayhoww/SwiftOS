ENTRY(_start)
MEMORY {
    code (RX)   : ORIGIN = 0x40100000, LENGTH = 1M      
    data (RWX)  : ORIGIN = 0x40200000, LENGTH = 4M
}
SECTIONS {
    .text.boot : { *(.text.boot) }
    .text : { *(.text) }

    .data : { *(.data) } > data
    .bss : { *(.bss COMMON) } 
    . = ALIGN(16);
    . += 1M;  /* space for stack */
    el0_stack_top = .;
    . += 1M;
    el1_stack_top = .;
}
