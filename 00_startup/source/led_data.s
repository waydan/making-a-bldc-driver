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
    .arch armv6

    .thumb
    .data

    .global red_led
    .type red_led, %object
red_led:
    .word   0x400FF0C0  @ GPIO D Address
    .word   1 << 6      @ Pin Number
    .word   green_led   @ Next

    .global green_led
    .type green_led, %object
green_led:
    .word   0x400FF100  @ GPIO E Address
    .word   1 << 29     @ Pin Number
    .word   blue_led    @ Next

    .global blue_led
    .type blue_led, %object
blue_led:
    .word   0x400FF100  @ GPIO E Address
    .word   1 << 25     @ Pin Number
    .word   red_led     @ Next

    .global led_state
    .type led_state, %object
led_state:
    .word   0           @ Flash State
    .word   red_led     @ RGB LED State

    .end
