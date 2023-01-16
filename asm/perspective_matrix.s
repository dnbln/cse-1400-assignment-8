.include "macros.s"

.data


.globl perspectiveMatrix
perspectiveMatrix:
.float 0.714074
.float 0.000000
.float 0.000000
.float 0.000000
.float 0.000000
.float 1.428148
.float 0.000000
.float 0.000000
.float 0.000000
.float 0.000000
.float -1.051282
.float -1.000000
.float 0.000000
.float 0.000000
.float -0.205128
.float 0.000000

.text
.globl loadPerspectiveMatrix

loadPerspectiveMatrix:
    pushq %rbp

    # keep %rdi = location
    movq $1, %rsi
    movq $0, %rdx
    movq $perspectiveMatrix, %rcx
    glCall glUniformMatrix4fv

    popq %rbp
    retq