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

    .thumb_func
    .global init
    .type startup, %function
init:
    @ enable clock gating for PORTs D and E
    ldr     r1, =0x40048038     @ SIM_SCGC5
    movs    r0, #3
    lsls    r0, #12
    ldr     r2, [r1]
    orrs    r2, r0
    str     r2, [r1]



    @ set pins D6, E25, and E29 as GPIO
    movs    r0, #7
    lsls    r0, #8      @ mask for mux field
    movs    r3, #1
    lsls    r3, #8      @ GPIO mux option

    ldr     r1, =0x4004C000     @ PORT_E
    @ D6
    ldr     r2, [r1, 0x18]
    bics    r2, r0
    orrs    r2, r3
    str     r2, [r1, 0x18]

    ldr     r1, =0x4004D000     @ PORT_E
    @ E25
    ldr     r2, [r1, 0x64]
    bics    r2, r0
    orrs    r2, r3
    str     r2, [r1, 0x64]
    @ E29
    ldr     r2, [r1, 0x74]
    bics    r2, r0
    orrs    r2, r3
    str     r2, [r1, 0x74]

    @ configure GPIO D pin 6 as output and set high (LED off)
    ldr     r1, =0x400FF0C0
    movs    r0, 1 << 6
    ldr     r2, [r1, 0x14]  @ PDDR read
    orrs    r2, r0
    str     r2, [r1, 0x14]  @ PDDR write
    str     r0, [r1, 0x4]   @ PSOR write

    @ configure GPIO E pins 25 and 29 as output and set high (LED off)
    ldr     r1, =0x400FF100
    movs    r0, #34
    lsls    r0, #24
    ldr     r2, [r1, 0x14]  @ PDDR read
    orrs    r2, r0
    str     r2, [r1, 0x14]  @ PDDR write
    str     r0, [r1, 0x4]   @ PSOR write

    @ Return from init
    bx      lr

.end
