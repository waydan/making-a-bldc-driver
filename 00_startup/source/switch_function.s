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

/* Initialize switch #2 */
    .thumb_func
    .global sw2_init
    .type sw2_init, %function
sw2_init:
    @ Enable clock gating to PORT B
    ldr     r1, =0x40048038     @ SIM_SCGC5
    movs    r0, #1
    lsls    r0, #10
    ldr     r2, [r1]
    orrs    r2, r0
    str     r2, [r1]

    @ Configure SW2 as an input with falling edge interrupt
    ldr     r1, =0x4004A000     @ PORT_B
    ldr     r0, =0x010A0110     @ Falling edge interrupt, MUX=>GPIO, passive filter
    str     r0, [r1, #0]

    @ Configure SW2 as an input
    ldr     r1, =0x400FF040     @ GPIO_B register
    movs    r0, #1
    ldr     r2, [r1, 0x14]
    bics    r2, r0
    str     r2, [r1, 0x14]
    bx      lr

/* Initialize switch #3 */
    .thumb_func
    .global sw3_init
    .type sw3_init, %function
sw3_init:
    @ Enable clock gating to PORT B
    ldr     r1, =0x40048038     @ SIM_SCGC5
    movs    r0, #1
    lsls    r0, #9
    ldr     r2, [r1]
    orrs    r2, r0
    str     r2, [r1]

    @ Configure SW2 as an input with falling edge interrupt
    ldr     r1, =0x40049000     @ PORT_A
    ldr     r0, =0x010A0110     @ Falling edge interrupt, MUX=>GPIO, passive filter
    str     r0, [r1, 0x10]

    @ Configure SW2 as an input
    ldr     r1, =0x400FF000     @ GPIO_A register
    movs    r0, 1 << 4
    ldr     r2, [r1, 0x14]
    bics    r2, r0
    str     r2, [r1, 0x14]
    bx      lr


    .thumb_func
    .global port_a_isr
    .type port_a_isr, %function
port_a_isr:
/*
Interrupt will be triggered by a falling edge on Switch #3
This function will change to the next LED in the R->G->B sequence
*/
    push    {r0-r3, lr}

    ldr     r3, =led_state  @ Pointer to LED State Var Object
    ldr     r0, [r3, #4]    @ Pointer to current RGB state
    ldm     r0, {r0-r2}     @ Pointer to next RGB state
    str     r2, [r3, #4]    @ Set next RGB state as current state

    @ Turn off old LED
    str     r1, [r0, #4]    @ Set output high to turn off LED
    
    @ Turn on new LED
    ldr     r0, [r3, #4]    @ GPIO port address
    ldm     r0, {r0, r1}    @ GPIO pin number
    str     r1, [r0, #8]    @ Set output low to turn on LED

    @ Clear the interrupt flag
    ldr     r1, =0x40049000     @ PORT_A
    ldr     r0, [r1, 0x10]
    str     r0, [r1, 0x10]

    @ Return
    pop     {r0-r3, pc}


    .thumb_func
    .global port_bcde_isr
    .type port_bcde_isr, %function
port_bcde_isr:
/*
Interrupt will be triggered by a falling edge on Switch #2
This function will change the flashing state variable 
*/
    push    {r0-r1, lr}

    ldr     r1, =led_state  @ Pointer to LED State Var Object
    ldr     r0, [r1, #0]    @ LED flash state variable
    mvns    r0, r0          @ Bitwise NOT r0
    str     r0, [r1, #0]    @ Toggle the LED flash state

    @ Clear the interrupt flag
    ldr     r1, =0x4004A000     @ PORT_B
    ldr     r0, [r1]
    str     r0, [r1]

    @ Return
    pop     {r0-r1, pc}

    .end
