.text
.globl geim_init

geim_init:
    pushq %rbp
    movq %rsp, %rbp

    // -8(%rbp) = window

    subq $16, %rsp

    movq $error_callback, %rdi      # move the pointer to error callbakc
    callq glfwSetErrorCallback      # call set error call back from OpenGL

    callq glfwInit                  # Call GLFW init
    orq %rax, %rax                  # test if it's 0
    jz geim_glfw_init_fail          #

    movq $0x00022002, %rdi # GLFW_CONTEXT_VERSION_MAJOR
    movq $4, %rsi          # major version 4
    callq glfwWindowHint


    movq $0x00022003, %rdi # GLFW_CONTEXT_VERSION_MINOR
    movq $5, %rsi          # minor version 5
    callq glfwWindowHint

    movq $0x00022008, %rdi # GLFW_OPENGL_PROFILE
    movq $0x00032001, %rsi # GLFW_OPENGL_CORE_PROFILE
    callq glfwWindowHint

    movq $0x00020003, %rdi # GLFW_RESIZABLE
    movq $0, %rsi          # FALSE
    callq glfwWindowHint


    movq $1440, %rdi
    movq $720, %rsi

.data
windowTitle:
    .asciz "Geim"
.text

    movq $windowTitle, %rdx
    movq $0, %rcx
    movq $0, %r8
    call glfwCreateWindow
    movq %rax, -8(%rbp)

    orq %rax, %rax
    jz geim_glfw_create_window_fail

    movq -8(%rbp), %rdi
    movq $key_callback, %rsi
    callq glfwSetKeyCallback

    movq -8(%rbp), %rdi
    movq $mousePosCallback, %rsi
    callq glfwSetCursorPosCallback

    movq -8(%rbp), %rdi
    callq glfwMakeContextCurrent

    movq $glfwGetProcAddress, %rdi
    callq gladLoadGLLoader

    movq $1, %rdi
    callq glfwSwapInterval

    movq -8(%rbp), %rax

    movq %rbp, %rsp
    popq %rbp
    ret

geim_glfw_init_fail:
    movq $1, %rdi
    callq exit

geim_glfw_create_window_fail:
    callq glfwTerminate
    movq $1, %rdi
    callq exit
