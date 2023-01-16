.text

.globl error_callback

error_callback:
    pushq %rbp
    movq %rsp, %rbp

.data
    formatError: .asciz "Error: %s\n"
.text

    movq $formatError, %rdi
    movq $0, %rax
    callq printf

    movq %rbp, %rsp
    popq %rbp
    ret


.globl key_callback

// %rdi = GLFWWindow* window
// %rsi = int key
// %rdx = int scancode
// %rcx = int action
// %r8 = int mods
key_callback:
    pushq %rbp
    movq %rsp, %rbp

    cmpq $256, %rsi # GLFW_KEY_ESCAPE
    jne key_callback_cmp_escape_fail

    cmpq $1, %rcx # GLFW_PRESS
    jne key_callback_cmp_escape_fail

    // %rdi = window already
    movq $1, %rsi # GLFW_TRUE
    callq glfwSetWindowShouldClose

key_callback_cmp_escape_fail:
    movq %rbp, %rsp
    popq %rbp
    ret

.bss

.globl mouseXpos
.lcomm mouseXpos, 4

.globl mouseYpos
.lcomm mouseYpos, 4

.text

.globl mousePosCallback

// %rdi = GLFWWindow* window
// %xmm0 = double xpos
// %xmm1 = double ypos
mousePosCallback:
    pushq %rbp
    movq %rsp, %rbp

    subq $16, %rsp

    movsd %xmm0, -8(%rbp)
    movsd %xmm1, -16(%rbp)

    pxor %xmm0, %xmm0 # zero xmm0
    cvtsd2ss -8(%rbp), %xmm0
    movss %xmm0, mouseXpos

    pxor %xmm0, %xmm0
    cvtsd2ss -16(%rbp), %xmm0
    movss %xmm0, mouseYpos

    movq %rbp, %rsp
    popq %rbp
    ret
