.text
.global main

.include "macros.s"

main:
    pushq %rbp
    movq %rsp, %rbp
    # -8(%rbp) = heartsPadOneToRender
    # -16(%rbp) = heartsPadTwoToRender
    subq $16, %rsp


    callq geim_init
    movq %rax, window

    callq load_gl_objects

    subq $16, %rsp
    movq window, %rdi
    leaq -8(%rbp), %rsi # width
    leaq -4(%rbp), %rdx # height
    callq glfwGetFramebufferSize

    movl $0, %edi # x
    movl $0, %esi # y
    movl -8(%rbp), %edx # width
    movl -4(%rbp), %ecx # height
    glCall glViewport

    addq $16, %rsp

    movsd oneDouble, %xmm0
    glCall glClearDepth

    movq $0x0B71, %rdi # GL_DEPTH_TEST
    glCall glEnable

    movq $0x0203, %rdi # GL_LEQUAL
    glCall glDepthFunc

    pxor %xmm0, %xmm0
    movsd oneDouble, %xmm1
    glCall glDepthRange

    call init_game_state
    movq $mouse_control_pad_fun, padone+24
    movq $beatable_control_pad_fun, padtwo+24


    movl $3, gameState+0
    movl $3, gameState+4
    movl $0, gameState+8
    movq $padOneLostImpl, gameState+16
    movq $padTwoLostImpl, gameState+24

main_loop:
    movq window, %rdi
    call glfwWindowShouldClose
    cmpq $0, %rax
    jne main_loop_end

    cmpl $0, gameState+8
    jne mainLoopGameEndedSkipLogicCall

    movq $padone, %rdi
    movq $padtwo, %rsi
    movq $ball, %rdx
    movq $gameState, %rcx
    call magick

mainLoopGameEndedSkipLogicCall:

    pxor %xmm0, %xmm0
    movaps %xmm0, %xmm1
    movaps %xmm0, %xmm2
    movss oneFloat, %xmm3

    glCall glClearColor

    movq $0x00004500, %rdi # GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT
    glCall glClear


    # draw cage
    movq cageVAOID, %rdi
    glCall glBindVertexArray

    movq $0, %rdi
    glCall glEnableVertexAttribArray

    movq cageProgram, %rdi
    glCall glUseProgram
    movq cageProgramProjectionUniformID, %rdi
    call loadPerspectiveMatrix

    movq $0x0001, %rdi
    movq $0, %rsi
    movq cageVertexCount, %rdx
    glCall glDrawArrays

    movq $0, %rdi
    glCall glDisableVertexAttribArray

    movq $0, %rdi
    glCall glBindVertexArray
    # end draw cage

    # draw projector
    movq projectorVAOID, %rdi
    glCall glBindVertexArray

    movq $0, %rdi
    glCall glEnableVertexAttribArray

    movq cageProjectorProgram, %rdi
    glCall glUseProgram
    movq cageProjectorProjectionUniformID, %rdi
    call loadPerspectiveMatrix

    movq cageProjectorZUniformID, %rdi
    movss ball+8, %xmm0 # ball.z
    glCall glUniform1f

    movq $0x0001, %rdi
    movq $0, %rsi
    movq $8, %rdx
    glCall glDrawArrays

    movq $0, %rdi
    glCall glDisableVertexAttribArray

    movq $0, %rdi
    glCall glBindVertexArray
    # end draw projector

    # draw pads

    movq padVAOID, %rdi
    glCall glBindVertexArray

    movq $0, %rdi
    glCall glEnableVertexAttribArray

    movq padProgram, %rdi
    glCall glUseProgram

    movq padProjMatrixUniformID, %rdi
    call loadPerspectiveMatrix

    # draw pad two

    movq padTransformationUniformID, %rdi
    movss padtwo+0, %xmm0 # x
    movss padtwo+4, %xmm1 # y
    movss padtwo+8, %xmm2 # z
    call loadTransformationMatrix

.data
padtwoColor:
.float 0.63, 0.0, 0.0
.text
    movq padColorUniformID, %rdi
    movss padtwoColor, %xmm0
    movss padtwoColor+4, %xmm1
    movss padtwoColor+8, %xmm2
    glCall glUniform3f

    movq $0x0004, %rdi # GL_TRIANGLES
    movq $0, %rsi
    movq $6, %rdx
    glCall glDrawArrays



    # draw pad one

    movq padTransformationUniformID, %rdi
    movss padone+0, %xmm0 # x
    movss padone+4, %xmm1 # y
    movss padone+8, %xmm2 # z
    call loadTransformationMatrix

.data
padoneColor:
.float 0.12, 0.69, 0.26
.text
    movq padColorUniformID, %rdi
    movss padoneColor, %xmm0
    movss padoneColor+4, %xmm1
    movss padoneColor+8, %xmm2
    glCall glUniform3f

    movq $0x0004, %rdi # GL_TRIANGLES
    movq $0, %rsi
    movq $6, %rdx
    glCall glDrawArrays

    movq $0, %rdi
    glCall glDisableVertexAttribArray

    movq $0, %rdi
    glCall glBindVertexArray

    # end draw pads


    movq ballVAOID, %rdi
    glCall glBindVertexArray

    movq $0, %rdi
    glCall glEnableVertexAttribArray

    movq $1, %rdi
    glCall glEnableVertexAttribArray

    movq ballProgram, %rdi
    glCall glUseProgram

    movq ballProjectionUniformID, %rdi
    call loadPerspectiveMatrix

    movq ballTransformationUniformID, %rdi
    movss ball+0, %xmm0 # x
    movss ball+4, %xmm1 # y
    movss ball+8, %xmm2 # z
    call loadTransformationMatrix

    movq $0x0004, %rdi  #GL_TRIANGLES
    movq $0, %rsi
    movq $30, %rdx
    glCall glDrawArrays

    movq $0, %rdi
    glCall glDisableVertexAttribArray

    movq $1, %rdi
    glCall glDisableVertexAttribArray

    movq $0, %rdi
    glCall glBindVertexArray

    # end of ball

    # hearts

    movq heartVAOID, %rdi
    glCall glBindVertexArray

    movq $0, %rdi
    glCall glEnableVertexAttribArray

    movq heartShaderProgram, %rdi
    glCall glUseProgram

    movq heartShaderProjectionUniformID, %rdi
    call loadPerspectiveMatrix

.data

CAGE_WIDTH: .float 0.5
CAGE_HEIGHT: .float 0.3
CAGE_START_DEPTH: .float -0.5
HEART_OFFX: .float 0.05
HEART_OFFY: .float 0.04
THREE: .float 3

.text

    # loops in hearts

    # store heartsToRenderPadOne on stack
    movl gameState+0, %eax
    movq %rax, -8(%rbp)

    # store heartsToRenderPadTwo on stack
    movl gameState+4, %eax
    movq %rax, -16(%rbp)

    cmpq $0, -16(%rbp)
    jne nonZeroHeartsToRenderPadTwo

    movq $3, -16(%rbp)
    movq $0x0408, %rdi # GL_FRONT_AND_BACK
    movq $0x1B01, %rsi # GL_LINE
    glCall glPolygonMode

nonZeroHeartsToRenderPadTwo:
    movq $0, %rbx
    forHeartsPadTwo:
        cmpq -16(%rbp), %rbx # heartsToRenderPadTwo
        jge forHeartsPadTwoEnd

        # x = -CAGE_WIDTH + (i - 3) * HEART_OFFX
        cvtsi2ss %ebx, %xmm0
        subss THREE, %xmm0
        mulss HEART_OFFX, %xmm0
        subss CAGE_WIDTH, %xmm0

        # y = -CAGE_HEIGHT + 3 * HEART_OFFY
        movss HEART_OFFY, %xmm1
        mulss THREE, %xmm1
        subss CAGE_HEIGHT, %xmm1

        # z = CAGE_START_DEPTH
        movss CAGE_START_DEPTH, %xmm2

        movq heartShaderTransformUniformID, %rdi
        callq loadTransformationMatrix

        movq heartShaderColorUniformID, %rdi
        movss padtwoColor, %xmm0
        movss padtwoColor+4, %xmm1
        movss padtwoColor+8, %xmm2
        glCall glUniform3f

        movq $0x0004, %rdi
        movq $0, %rsi
        movq $36, %rdx

        glCall glDrawArrays

        incq %rbx
        jmp forHeartsPadTwo
    forHeartsPadTwoEnd:

    cmpq $0, -8(%rbp)
    jne nonZeroHeartsToRenderPadOne

    movq $3, -8(%rbp)
    movq $0x0408, %rdi # GL_FRONT_AND_BACK
    movq $0x1B01, %rsi # GL_LINE
    glCall glPolygonMode

    jmp zeroHeartsToRenderPadOneIfEnd
nonZeroHeartsToRenderPadOne:
    movq $0x0408, %rdi # GL_FRONT_AND_BACK
    movq $0x1B02, %rsi # GL_FILL
    glCall glPolygonMode

zeroHeartsToRenderPadOneIfEnd:
    movq $0, %rbx
    forHeartsPadOne:
        cmpq -8(%rbp), %rbx # heartsToRenderPadOne
        jge forHeartsPadOneEnd

        # x = -CAGE_WIDTH + (i - 3) * HEART_OFFX
        cvtsi2ss %ebx, %xmm0
        subss THREE, %xmm0
        mulss HEART_OFFX, %xmm0
        subss CAGE_WIDTH, %xmm0

        # y = -CAGE_HEIGHT + HEART_OFFY
        movss HEART_OFFY, %xmm1
        subss CAGE_HEIGHT, %xmm1

        # z = CAGE_START_DEPTH
        movss CAGE_START_DEPTH, %xmm2

        movq heartShaderTransformUniformID, %rdi
        callq loadTransformationMatrix

        movq heartShaderColorUniformID, %rdi
        movss padoneColor, %xmm0
        movss padoneColor+4, %xmm1
        movss padoneColor+8, %xmm2
        glCall glUniform3f

        movq $0x0004, %rdi
        movq $0, %rsi
        movq $36, %rdx

        glCall glDrawArrays

        incq %rbx
        jmp forHeartsPadOne
    forHeartsPadOneEnd:

    movq $0x0408, %rdi # GL_FRONT_AND_BACK
    movq $0x1B02, %rsi # GL_FILL
    glCall glPolygonMode

    movq $0, %rdi
    glCall glDisableVertexAttribArray

    movq $0, %rdi
    glCall glBindVertexArray

    movq window, %rdi
    callq glfwSwapBuffers

    callq glfwPollEvents

    jmp main_loop

main_loop_end:
    movq window, %rdi
    call glfwDestroyWindow

    callq glfwTerminate

    movq $0, %rax

    movq %rbp, %rsp
    popq %rbp
    ret

# (
#   %rdi = state : GameState*
#   %rsi = padone : Pad*
#   %rdx = padtwo : Pad*
#   %rcx = ball : Ball*
# )
padOneLostImpl:
    pushq %rbp
    movq %rsp, %rbp

    subl $1, (%rdi) # heartsOne
    jnz padOneLostImplNonZeroHearts

    movl $1, 8(%rdi)

    jmp padOneLostImplEnd

padOneLostImplNonZeroHearts:
    callq reinit_game_state

padOneLostImplEnd:
    movq %rbp, %rsp
    popq %rbp
    retq

# (
#   %rdi = state : GameState*
#   %rsi = padone : Pad*
#   %rdx = padtwo : Pad*
#   %rcx = ball : Ball*
# )
padTwoLostImpl:
    pushq %rbp
    movq %rsp, %rbp

    subl $1, 4(%rdi) # heartsTwo
    jnz padTwoLostImplNonZeroHearts

    movl $1, 8(%rdi)

    jmp padTwoLostImplEnd

padTwoLostImplNonZeroHearts:
    callq reinit_game_state

padTwoLostImplEnd:
    movq %rbp, %rsp
    popq %rbp
    retq
