@ MIT License
@
@ Copyright (c) 2019 Daniel Way
@ 
@ Permission is hereby granted, free of charge, to any person obtaining a copy
@ of this software and associated documentation files (the "Software"), to deal
@ in the Software without restriction, including without limitation the rights
@ to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
@ copies of the Software, and to permit persons to whom the Software is
@ furnished to do so, subject to the following conditions:
@ 
@ The above copyright notice and this permission notice shall be included in all
@ copies or substantial portions of the Software.
@
@ THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
@ IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
@ FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
@ AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
@ LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
@ OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
@ SOFTWARE.


    .syntax unified
    .arch armv6-m

    .thumb
    .text

    .equ startup_clock, 20971520   @ Frequency of system clock at reset

/* Initialize the SysTick timer module and set the interrupt period */
    .thumb_func
    .global systick_init
    .type systick_init, %function
systick_init:

    @ From the ARM Cortex-M0+ Generic User Guide
    @ The correct initialization sequence for the SysTick counter is:
    @ 1. Program reload value.
    @ 2. Clear current value.
    @ 3. Program Control and Status register.

    @ Only run the init function at the start of program execution
    ldr     r1, =0xE000E010             @ SysTick base address
    ldr     r0, =startup_clock / 4 - 1  @ 2 Hz frequency
    str     r0, [r1, #4]                @ Write reload value
    str     r0, [r1, #8]                @ Clear SysTick counter by writing any value

    @ Enable the SysTick and interrupt driven from processor clock
    ldr     r0, =0x00000007
    str     r0, [r1]
    bx      lr


/* SysTick Interrupt Service Routine */
    .thumb_func
    .global systick_isr
    .type systick_isr, %function
systick_isr:
    push    {r0-r2, lr}
    ldr     r0, =led_state
    ldm     r0, {r0, r1}
    ldm     r1, {r1, r2}
    @ If the flash state variable is not 0, flash the led
    cmp     r0, #0
    bpl     .led_on
.led_toggle:
    str     r2, [r1, 0xC]   @ PTOR write
    pop     {r0, r1, r2, pc}
.led_on:
    str     r2, [r1, 0x8]   @ PCOR write
    pop     {r0-r2, pc}

    .end
