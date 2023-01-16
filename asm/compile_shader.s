.text

.include "macros.s"

.globl compile_shader

// %rdi = const char* vertex.glsl
// %rsi = const char* fragment.glsl
compile_shader:
    pushq %rbp
    movq %rsp, %rbp

    // -8 (%rbp) = vertex.glsl
    // -16(%rbp) = fragment.glsl
    // -24(%rbp) = vertex_shader
    // -32(%rbp) = fragment_shader
    // -40(%rbp) = program
    subq $48, %rsp

    movq %rdi, -8(%rbp)
    movq %rsi, -16(%rbp)

    // create and compile vertex shader
    movq $0x8B31, %rdi # GL_VERTEX_SHADER
    glCall glCreateShader

    movq %rax, -24(%rbp)
    movq %rax, %rdi
    movq $1, %rsi
    leaq -8(%rbp), %rdx
    movq $0, %rcx
    glCall glShaderSource

    movq -24(%rbp), %rdi
    glCall glCompileShader

    // create and compile fragment shader
    movq $0x8B30, %rdi # GL_FRAGMENT_SHADER
    glCall glCreateShader

    movq %rax, -32(%rbp)
    movq %rax, %rdi
    movq $1, %rsi
    leaq -16(%rbp), %rdx
    movq $0, %rcx
    glCall glShaderSource

    movq -32(%rbp), %rdi
    glCall glCompileShader

    glCall glCreateProgram

    movq %rax, -40(%rbp)
    movq %rax, %rdi
    movq -24(%rbp), %rsi
    glCall glAttachShader

    movq -40(%rbp), %rdi
    movq -32(%rbp), %rsi
    glCall glAttachShader

    movq -40(%rbp), %rdi
    glCall glLinkProgram

    movq -24(%rbp), %rdi
    glCall glDeleteShader

    movq -32(%rbp), %rdi
    glCall glDeleteShader

    movq -40(%rbp), %rax

    movq %rbp, %rsp
    popq %rbp
    ret
