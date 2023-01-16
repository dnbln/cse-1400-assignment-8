.include "macros.s"

.data

minX: .float -0.35
maxX: .float 0.35
minY: .float -0.2
maxY: .float 0.2

.text

absfun:
    pxor %xmm1, %xmm1
    comiss %xmm1, %xmm0
    jae absfun_end
    invertSignBit xmm0
absfun_end:
    ret

# (
#   %rdi = pad : Pad*
#   %rsi = ball : Ball*
# ) -> bool
inPadRange:
    pushq %rbp
    movq %rsp, %rbp
    pushq %rdi # -8(%rbp)
    pushq %rsi # -16(%rbp)

.data
PWplusBR: .float 0.2
PHplusBR: .float 0.15
.text

    movss (%rdi), %xmm0 # pad.x
    subss (%rsi), %xmm0 # ball.x
    callq absfun

    comiss PWplusBR, %xmm0
    ja inPadRangeFalse

    movq -8(%rbp), %rdi
    movq -16(%rbp), %rsi
    movss 4(%rdi), %xmm0 # pad.y
    subss 4(%rsi), %xmm0 # ball.y
    callq absfun

    comiss PHplusBR, %xmm0
    ja inPadRangeFalse

    movq $1, %rax
    jmp inPadRangeEnd
inPadRangeFalse:
    movq $0, %rax
inPadRangeEnd:
    movq %rbp, %rsp
    popq %rbp
    retq

.globl magick

# (
#   %rdi = padone: Pad*
#   %rsi = padtwo: Pad*
#   %rdx = ball: Ball*
#   %rcx = state: GameState*
# ) -> void
magick:
    pushq %rbp
    movq %rsp, %rbp

    # -8(%rbp) = padone (ptr, param)
    # -16(%rbp) = padtwo (ptr, param)
    # -24(%rbp) = ball (ptr, param)
    # -32(%rbp) = state (ptr, param)
    # -40(%rbp) = callee saved %rbx
    subq $48, %rsp
    movq %rdi, -8(%rbp)
    movq %rsi, -16(%rbp)
    movq %rdx, -24(%rbp)
    movq %rcx, -32(%rbp)

    movq %rbx, -40(%rbp)

    # movq -8(%rbp), %rdi
    movq 24(%rdi), %rbx # controller_fun
    orq %rbx, %rbx
    jz padone_nocontroller

    movss (%rdi), %xmm0 # x
    invertSignBit xmm0
    movss %xmm0, 12(%rdi) # deltaX

    movss 4(%rdi), %xmm0 # y
    invertSignBit xmm0
    movss %xmm0, 16(%rdi) # deltaY

    # %rdi = padone already
    movq -24(%rbp), %rsi # %rsi = ball

    callq *%rbx

    movq -8(%rbp), %rdi
    movss (%rdi), %xmm0 # x
    movss minX, %xmm1
    movss maxX, %xmm2
    call clamp
    movss %xmm0, (%rdi)

    movss 4(%rdi), %xmm0 # y
    movss minY, %xmm1
    movss maxY, %xmm2
    call clamp
    movss %xmm0, 4(%rdi) # y

    movss 12(%rdi), %xmm0 # deltaX
    addss (%rdi), %xmm0 # x
    movss %xmm0, 12(%rdi) # write back to deltaX

    movss 16(%rdi), %xmm0 # deltaY
    addss 4(%rdi), %xmm0 # y
    movss %xmm0, 16(%rdi) # write back to deltaY


padone_nocontroller:



    movq -16(%rbp), %rdi
    movq 24(%rdi), %rbx # controller_fun
    orq %rbx, %rbx
    jz padtwo_nocontroller


    movss (%rdi), %xmm0 # x
    invertSignBit xmm0
    movss %xmm0, 12(%rdi) # deltaX

    movss 4(%rdi), %xmm0 # y
    invertSignBit xmm0
    movss %xmm0, 16(%rdi) # deltaY

    # %rdi = padone already
    movq -24(%rbp), %rsi # %rsi = ball

    callq *%rbx

    movq -16(%rbp), %rdi
    movss (%rdi), %xmm0 # x
    movss minX, %xmm1
    movss maxX, %xmm2
    call clamp
    movss %xmm0, (%rdi)

    movss 4(%rdi), %xmm0 # y
    movss minY, %xmm1
    movss maxY, %xmm2
    call clamp
    movss %xmm0, 4(%rdi) # y

    movss 12(%rdi), %xmm0 # deltaX
    addss (%rdi), %xmm0 # x
    movss %xmm0, 12(%rdi) # write back to deltaX

    movss 16(%rdi), %xmm0 # deltaY
    addss 4(%rdi), %xmm0 # y
    movss %xmm0, 16(%rdi) # write back to deltaY

padtwo_nocontroller:



    movq -24(%rbp), %rdi # ball

    movss (%rdi), %xmm0 # x
    addss 12(%rdi), %xmm0 # dirX
    movss %xmm0, (%rdi) # write back to x

    movss 4(%rdi), %xmm0 # y
    addss 16(%rdi), %xmm0 # dirY
    movss %xmm0, 4(%rdi) # write back to y

    movss 8(%rdi), %xmm0 # z
    addss 20(%rdi), %xmm0 # dirZ
    movss %xmm0, 8(%rdi) # write back to z


.data

MIN_Z_DIF: .float 0.04 # 0.8 * BALL_RADIUS
MAX_Z_DIF: .float 0.06 # 1.2 * BALL_RADIUS

.text

    movq -8(%rbp), %rdi # padone
    movq -24(%rbp), %rsi # ball
    movss 8(%rsi), %xmm0 # ball.z
    subss 8(%rdi), %xmm0 # padone.z
    movss MAX_Z_DIF, %xmm1
    invertSignBit xmm1
    comiss %xmm1, %xmm0
    jb ball_not_close_to_padone

    movss MIN_Z_DIF, %xmm1
    invertSignBit xmm1
    comiss %xmm1, %xmm0
    ja ball_not_close_to_padone

    movss 20(%rsi), %xmm2 # ball.dirZ
    pxor %xmm3, %xmm3
    comiss %xmm3, %xmm2
    jbe ball_not_hit_padone

    # %rdi = pad
    # %rsi = ball
    callq inPadRange

    cmpq $0, %rax
    je ball_not_hit_padone

    # ball hit the pad

    movq -24(%rbp), %rsi # %rsi = ball
    movss 20(%rsi), %xmm0 # ball.dirZ
    invertSignBit xmm0
    movss %xmm0, 20(%rsi) # ball.dirZ

.data
BALL_PAD_INERTIA_FACTOR: .float 0.1
.text

    movq -8(%rbp), %rdi # %rdi = padOne
    movq -24(%rbp), %rsi # %rsi = ball
    movss 12(%rdi), %xmm0 # deltaX
    mulss BALL_PAD_INERTIA_FACTOR, %xmm0
    movss 12(%rsi), %xmm1 # dirX
    addss %xmm0, %xmm1
    movss %xmm1, 12(%rsi) # dirX


    movss 16(%rdi), %xmm0 # deltaY
    mulss BALL_PAD_INERTIA_FACTOR, %xmm0
    movss 16(%rsi), %xmm1 # dirY
    addss %xmm0, %xmm1
    movss %xmm1, 16(%rsi) # dirY

ball_not_hit_padone:

ball_not_close_to_padone:

    movq -16(%rbp), %rdi # padtwo
    movq -24(%rbp), %rsi # ball
    movss 8(%rsi), %xmm0 # ball.z
    subss 8(%rdi), %xmm0 # padtwo.z
    comiss MAX_Z_DIF, %xmm0
    ja ball_not_close_to_padtwo

    comiss MIN_Z_DIF, %xmm0
    jb ball_not_close_to_padtwo

    movss 20(%rsi), %xmm2 # ball.dirZ
    pxor %xmm3, %xmm3
    comiss %xmm3, %xmm2
    jae ball_not_hit_padtwo

    # %rdi = pad
    # %rsi = ball
    callq inPadRange

    cmpq $0, %rax
    je ball_not_hit_padtwo

    # ball hit the pad

    movq -24(%rbp), %rsi # %rsi = ball
    movss 20(%rsi), %xmm0 # ball.dirZ
    invertSignBit xmm0
    movss %xmm0, 20(%rsi) # ball.dirZ

    movq -16(%rbp), %rdi # %rdi = padTwo
    movq -24(%rbp), %rsi # %rsi = ball
    movss 12(%rdi), %xmm0 # deltaX
    mulss BALL_PAD_INERTIA_FACTOR, %xmm0
    movss 12(%rsi), %xmm1 # dirX
    addss %xmm0, %xmm1
    movss %xmm1, 12(%rsi) # dirX


    movss 16(%rdi), %xmm0 # deltaY
    mulss BALL_PAD_INERTIA_FACTOR, %xmm0
    movss 16(%rsi), %xmm1 # dirY
    addss %xmm0, %xmm1
    movss %xmm1, 16(%rsi) # dirY

ball_not_hit_padtwo:

ball_not_close_to_padtwo:

    movq -8(%rbp), %rdi # padone
    movq -24(%rbp), %rsi # ball

    movss 8(%rsi), %xmm0
    movss 8(%rdi), %xmm1
    comiss %xmm1, %xmm0
    jb statePadoneNotLost

    movq -32(%rbp), %rdi # state
    movq 16(%rdi), %rbx # state.padOneLost
    movq -8(%rbp), %rsi # padOne
    movq -16(%rbp), %rdx # padTwo
    movq -24(%rbp), %rcx # ball

    callq *%rbx

statePadoneNotLost:

    movq -16(%rbp), %rdi # padtwo
    movq -24(%rbp), %rsi # ball

    movss 8(%rsi), %xmm0
    movss 8(%rdi), %xmm1
    comiss %xmm1, %xmm0
    ja statePadtwoNotLost

    movq -32(%rbp), %rdi # state
    movq 24(%rdi), %rbx # state.padTwoLost
    movq -8(%rbp), %rsi # padOne
    movq -16(%rbp), %rdx # padTwo
    movq -24(%rbp), %rcx # ball

    callq *%rbx

statePadtwoNotLost:

.data
CWminusBR: .float 0.45
CHminusBR: .float 0.25
.text

    movq -24(%rbp), %rdi # %rdi = ball
    movss (%rdi), %xmm0 # x
    movss CWminusBR, %xmm1
    comiss %xmm1, %xmm0
    jb ball_didnt_hit_right_cage

    pxor %xmm2, %xmm2 # %xmm2 = 0
    movss 12(%rdi), %xmm3 # ball.dirX
    comiss %xmm2, %xmm3
    jbe ball_didnt_hit_right_cage

    invertSignBit xmm3
    movss %xmm3, 12(%rdi) # ball.dirX

ball_didnt_hit_right_cage:

    invertSignBit xmm1 # xmm1 = -CAGE_WIDTH + BALL_RADIUS
    comiss %xmm1, %xmm0
    ja ball_didnt_hit_left_cage

    pxor %xmm2, %xmm2 # %xmm2 = 0
    movss 12(%rdi), %xmm3 # ball.dirX
    comiss %xmm2, %xmm3
    jae ball_didnt_hit_left_cage

    invertSignBit xmm3
    movss %xmm3, 12(%rdi) # ball.dirX

ball_didnt_hit_left_cage:

    movss 4(%rdi), %xmm0 # y
    movss CHminusBR, %xmm1
    comiss %xmm1, %xmm0
    jb ball_didnt_hit_top_cage

    pxor %xmm2, %xmm2 # %xmm2 = 0
    movss 16(%rdi), %xmm3 # ball.dirY
    comiss %xmm2, %xmm3
    jbe ball_didnt_hit_top_cage

    invertSignBit xmm3
    movss %xmm3, 16(%rdi) # ball.dirY

ball_didnt_hit_top_cage:

    invertSignBit xmm1 # xmm1 = -CAGE_HEIGHT + BALL_RADIUS
    comiss %xmm1, %xmm0
    ja ball_didnt_hit_bottom_cage

    pxor %xmm2, %xmm2 # %xmm2 = 0
    movss 16(%rdi), %xmm3 # ball.dirY
    comiss %xmm2, %xmm3
    jae ball_didnt_hit_bottom_cage

    invertSignBit xmm3
    movss %xmm3, 16(%rdi) # ball.dirY

ball_didnt_hit_bottom_cage:


    movq -40(%rbp), %rbx

    movq %rbp, %rsp
    popq %rbp
    retq

# doesn't touch %rdi
clamp:
    pushq  %rbp
    movq %rsp, %rbp

    subq $16, %rsp

    movss %xmm0, -4(%rbp)
    movss %xmm1, -8(%rbp)
    movss %xmm2, -12(%rbp)
    movss -4(%rbp), %xmm1
    movss -8(%rbp), %xmm0
    ucomiss %xmm1, %xmm0
    jbe clamp_xGrM
    movss -8(%rbp), %xmm0
    jmp clamp_end
clamp_xGrM:
    movss -4(%rbp), %xmm0
    ucomiss -12(%rbp), %xmm0
    jbe clamp_xLem
    movss -12(%rbp), %xmm0
    jmp clamp_end
clamp_xLem:
    movss -4(%rbp), %xmm0
clamp_end:
    movq %rbp, %rsp
    popq %rbp
    retq

