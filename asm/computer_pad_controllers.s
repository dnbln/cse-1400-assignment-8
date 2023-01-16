.include "macros.s"

.text

.global unbeatable_control_pad_fun
unbeatable_control_pad_fun:
    pushq %rbp
    movq %rsp, %rbp

    movss (%rsi), %xmm0
    movss %xmm0, (%rdi)

    movss 4(%rsi), %xmm0
    movss %xmm0, 4(%rdi)

    movq %rbp, %rsp
    popq %rbp
    ret



.global beatable_control_pad_fun
beatable_control_pad_fun:
    pushq %rbp
    movq %rsp, %rbp

    movss 20(%rsi), %xmm0
    pxor %xmm1, %xmm1
    comiss %xmm0, %xmm1
    jbe ballGoingForward
.data
DIFFICULTY_SPEED: .float 0.8
.text
        movss (%rdi), %xmm0
        movss 12(%rsi), %xmm1
        mulss DIFFICULTY_SPEED, %xmm1
        addss %xmm1, %xmm0
        movss %xmm0, (%rdi)

        movss 4(%rdi), %xmm0
        movss 16(%rsi), %xmm1
        mulss DIFFICULTY_SPEED, %xmm1
        addss %xmm1, %xmm0
        movss %xmm0, 4(%rdi)

        jmp control_pad_end

    ballGoingForward:
.data
CENTER_SPEED: .float 0.03
.text
        movss (%rdi), %xmm0
        movaps %xmm0, %xmm1
        invertSignBit xmm1
        mulss CENTER_SPEED, %xmm1
        addss %xmm1, %xmm0
        movss %xmm0, (%rdi)

        movss 4(%rdi), %xmm0
        movaps %xmm0, %xmm1
        invertSignBit xmm1
        mulss CENTER_SPEED, %xmm1
        addss %xmm1, %xmm0
        movss %xmm0, 4(%rdi)

    control_pad_end:

    movq %rbp, %rsp
    popq %rbp
    ret