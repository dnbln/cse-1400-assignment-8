.include "macros.s"

.data

.globl transformationMatrix
transformationMatrix:
.float 1 # +0
.float 0
.float 0
.float 0

.float 0 # +16
.float 1
.float 0
.float 0

.float 0 # +32
.float 0
.float 1
.float 0

.float 0 # +48
.float 0
.float 0
.float 1

.text

# (
#    %xmm0 = x: float,
#    %xmm1 = y: float,
#    %xmm2 = z: float
# ) -> (%rax = float*)
.globl makeTransformationMatrix
makeTransformationMatrix:
    pushq %rbp
    movq %rsp, %rbp

    movss %xmm0, transformationMatrix+48
    movss %xmm1, transformationMatrix+52
    movss %xmm2, transformationMatrix+56

    movq $transformationMatrix, %rax

    movq %rbp, %rsp
    popq %rbp
    retq

# (
#    %rdi = location: int,
#    %xmm0 = x: float,
#    %xmm1 = y: float,
#    %xmm2 = z: float
# ) -> void
.globl loadTransformationMatrix
loadTransformationMatrix:
    pushq %rbp
    movq %rsp, %rbp

    callq makeTransformationMatrix

    movq $1, %rsi
    movq $0, %rdx
    movq %rax, %rcx
    glCall glUniformMatrix4fv

    movq %rbp, %rsp
    popq %rbp
    retq