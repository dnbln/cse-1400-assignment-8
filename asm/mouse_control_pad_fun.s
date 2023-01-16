.include "macros.s"

.text

.globl mouse_control_pad_fun

// %rdi = Pad* self
// %rsi = Ball* ball

mouse_control_pad_fun:
    pushq %rbp
    movq %rsp, %rbp

    subq $16, %rsp

.data

MOUSE_X_SCALING:
.float 1.4

MOUSE_Y_SCALING:
.float 0.73

WINDOW_WIDTH:
.float 1440

WINDOW_HEIGHT:
.float 720

TWO:
.float 2

.text
    movss mouseXpos, %xmm0
    movss WINDOW_WIDTH, %xmm1
    divss %xmm1, %xmm0
    movss MOUSE_X_SCALING, %xmm1
    mulss %xmm1, %xmm0
    movss MOUSE_X_SCALING, %xmm1
    movss TWO, %xmm2
    divss %xmm2, %xmm1
    subss %xmm1, %xmm0
    movss %xmm0, (%rdi) # pad.x

    movss mouseYpos, %xmm0
    movss WINDOW_HEIGHT, %xmm1
    divss %xmm1, %xmm0
    movss MOUSE_Y_SCALING, %xmm1
    mulss %xmm1, %xmm0
    movss MOUSE_Y_SCALING, %xmm1
    movss TWO, %xmm2
    divss %xmm2, %xmm1
    subss %xmm1, %xmm0
    invertSignBit xmm0
    movss %xmm0, 4(%rdi) # pad.y

    movq %rbp, %rsp
    popq %rbp
    ret
