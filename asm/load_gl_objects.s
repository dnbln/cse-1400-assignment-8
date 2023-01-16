.include "macros.s"

.text
.globl load_gl_objects

load_gl_objects:
    // prologue
    pushq %rbp
    movq %rsp, %rbp

    // pad program
.data

padProgramVS:
.ascii      "#version 450 core\n"
.ascii      "layout (location = 0) in vec3 vPos;\n"
.ascii      "uniform mat4 projection;\n"
.ascii      "uniform mat4 transformation;\n"
.ascii      "void main()\n"
.ascii      "{\n"
.ascii      "    gl_Position = projection * transformation * vec4(vPos, 1.0);\n"
.ascii      "}\n"
.asciz      ""

padProgramFS:
.ascii      "#version 450 core\n"
.ascii      "out vec4 FragColor;\n"
.ascii      "\n"
.ascii      "uniform vec3 padColor;\n"
.ascii      "void main()\n"
.ascii      "{\n"
.ascii      "    FragColor = vec4(padColor, 1.0);\n"
.ascii      "}\n"
.asciz      ""

padProjectionName: .asciz "projection"
padTransformationName: .asciz "transformation"
padColorName: .asciz "padColor"

.text
    movq $padProgramVS, %rdi
    movq $padProgramFS, %rsi
    callq compile_shader
    movq %rax, padProgram

    // get uniforms
    movq %rax, %rdi
    movq $padProjectionName, %rsi
    glCall glGetUniformLocation
    movq %rax, padProjMatrixUniformID

    movq padProgram, %rdi
    movq $padTransformationName, %rsi
    glCall glGetUniformLocation
    movq %rax, padTransformationUniformID

    movq padProgram, %rdi
    movq $padColorName, %rsi
    glCall glGetUniformLocation
    movq %rax, padColorUniformID

.data

cageProgramVS:
.ascii      "#version 450 core\n"
.ascii      "layout (location = 0) in vec3 vPos;\n"
.ascii      "uniform mat4 projection;\n"
.ascii      "void main()\n"
.ascii      "{\n"
.ascii      "    gl_Position = projection * vec4(vPos, 1.0);\n"
.ascii      "}\n"
.asciz      ""

cageProgramFS:
.ascii      "#version 450 core\n"
.ascii      "out vec4 FragColor;\n"
.ascii      "\n"
.ascii      "void main()\n"
.ascii      "{\n"
.ascii      "    FragColor = vec4(0.25, 0.99, 1.0, 1.0);\n"
.ascii      "}\n"
.asciz      ""

cageProjectionName: .asciz "projection"

.text
    movq $cageProgramVS, %rdi
    movq $cageProgramFS, %rsi
    callq compile_shader
    movq %rax, cageProgram

    movq %rax, %rdi
    movq $cageProjectionName, %rsi
    glCall glGetUniformLocation
    movq %rax, cageProgramProjectionUniformID

.data

ballProgramVS:
.ascii      "#version 450 core\n"
.ascii      "layout (location = 0) in vec3 vPos;\n"
.ascii      "layout (location = 1) in vec3 vNorm;\n"
.ascii      "layout (location = 0) out vec3 fragNorm;\n"
.ascii      "uniform mat4 transformation;\n"
.ascii      "uniform mat4 projection;\n"
.ascii      "void main()\n"
.ascii      "{\n"
.ascii      "    gl_Position = projection * transformation * vec4(vPos, 1.0);\n"
.ascii      "    fragNorm = vNorm;\n"
.ascii      "}\n"
.asciz      ""

ballProgramFS:
.ascii      "#version 450 core\n"
.ascii      "layout (location = 0) in vec3 fragNorm;"
.ascii      "out vec4 FragColor;\n"
.ascii      "\n"
.ascii      "void main()\n"
.ascii      "{\n"
.ascii      "    vec3 lightVector = normalize(vec3(-1, 1, 1));\n"
.ascii      "    float diffuseLighting = dot(lightVector, fragNorm) * 0.3 + 0.5;\n"
.ascii      "    vec3 color = vec3(1.0, 1.0, 1.0) * diffuseLighting;\n"
.ascii      "    FragColor = vec4(color, 1.0);\n"
.ascii      "}\n"
.asciz      ""

ballTransformationUniformName: .asciz "transformation"
ballProjectionUniformName: .asciz "projection"

.text
    movq $ballProgramVS, %rdi
    movq $ballProgramFS, %rsi
    callq compile_shader
    movq %rax, ballProgram

    movq %rax, %rdi
    movq $ballTransformationUniformName, %rsi
    glCall glGetUniformLocation
    movq %rax, ballTransformationUniformID

    movq ballProgram, %rdi
    movq $ballProjectionUniformName, %rsi
    glCall glGetUniformLocation
    movq %rax, ballProjectionUniformID

.data

cageProjectorProgramVS:
.ascii      "#version 450 core\n"
.ascii      "layout (location = 0) in vec3 vPos;\n"
.ascii      "uniform mat4 projection;\n"
.ascii      "uniform float z;\n"
.ascii      "void main()\n"
.ascii      "{\n"
.ascii      "    gl_Position = projection * vec4(vPos.xy, vPos.z + z, 1.0);\n"
.ascii      "}\n"
.asciz      ""

cageProjectorProgramFS:
.ascii      "#version 450 core\n"
.ascii      "out vec4 FragColor;\n"
.ascii      "\n"
.ascii      "void main()\n"
.ascii      "{\n"
.ascii      "    FragColor = vec4(1.0, 1.0, 1.0, 1.0);\n"
.ascii      "}\n"
.asciz      ""

cageProjectorProjectionUniformName: .asciz "projection"
cageProjectorZUniformName: .asciz "z"


.text
    movq $cageProjectorProgramVS, %rdi
    movq $cageProjectorProgramFS, %rsi
    callq compile_shader
    movq %rax, cageProjectorProgram

    movq %rax, %rdi
    movq $cageProjectorProjectionUniformName, %rsi
    glCall glGetUniformLocation
    movq %rax, cageProjectorProjectionUniformID

    movq cageProjectorProgram, %rdi
    movq $cageProjectorZUniformName, %rsi
    glCall glGetUniformLocation
    movq %rax, cageProjectorZUniformID

.data
heartShaderProgramVS:
.ascii      "#version 450 core\n"
.ascii      "layout (location = 0) in vec3 vPos;\n"
.ascii      "uniform mat4 projection;\n"
.ascii      "uniform mat4 transform;\n"
.ascii      "void main()\n"
.ascii      "{\n"
.ascii      "    gl_Position = projection * transform * vec4(vPos, 1.0);\n"
.ascii      "}\n"
.asciz      ""

heartShaderProgramFS:
.ascii      "#version 450 core\n"
.ascii      "out vec4 FragColor;\n"
.ascii      "uniform vec3 heartColor;\n"
.ascii      "\n"
.ascii      "void main()\n"
.ascii      "{\n"
.ascii      "    FragColor = vec4(heartColor, 1.0);\n"
.ascii      "}\n"
.asciz      ""

heartShaderProjectionUniformName: .asciz "projection"
heartShaderTransformUniformName: .asciz "transform"
heartShaderColorUniformName: .asciz "heartColor"

.text

    movq $heartShaderProgramVS, %rdi
    movq $heartShaderProgramFS, %rsi
    callq compile_shader
    movq %rax, heartShaderProgram

    movq %rax, %rdi
    movq $heartShaderProjectionUniformName, %rsi
    glCall glGetUniformLocation
    movq %rax, heartShaderProjectionUniformID

    movq heartShaderProgram, %rdi
    movq $heartShaderTransformUniformName, %rsi
    glCall glGetUniformLocation
    movq %rax, heartShaderTransformUniformID

    movq heartShaderProgram, %rdi
    movq $heartShaderColorUniformName, %rsi
    glCall glGetUniformLocation
    movq %rax, heartShaderColorUniformID

    # pad vao
    movq $padVerticesPos, %rdi # buffer
    movq $18, %rsi # 18 floats
    call simple_vao
    movq %rax, padVAOID

    # cage vao
    movq $cagePosBuffer, %rdi # buffer
    movq $cageFloatsCount, %rsi # count
    call simple_vao
    movq %rax, cageVAOID

    # ball vao
    movq $ballVpos, %rdi
    movq $ballNormals, %rsi
    movq $(30*3), %rdx # 30 vertexes, 3 floats / vertex
    call ball_vao
    movq %rax, ballVAOID

    # cage projector vao
    movq $cageProjectorPos, %rdi
    movq $(8*3), %rsi
    call simple_vao
    movq %rax, projectorVAOID

    # heart vao
    movq $heartPos, %rdi
    movq $36, %rsi
    call simple_vao
    movq %rax, heartVAOID

    // epilogue
    movq %rsp, %rbp
    popq %rbp
    retq



# (
#   %rdi = buffer: float*
#   %rsi = count: i32
# ) -> vaoID: i32
simple_vao:
    pushq %rbp
    movq %rsp, %rbp

    # -8(%rbp) = buffer (ptr, param)
    # -16(%rbp) = count (i32, param)
    # -24(%rbp) = vaoID (i32)
    # -32(%rbp) = vboID (i32)
    subq $32, %rsp
    movq %rdi, -8(%rbp)
    movq %rsi, -16(%rbp)

    movq $1, %rdi
    leaq -24(%rbp), %rsi
    glCall glGenVertexArrays

    movl -24(%rbp), %edi
    glCall glBindVertexArray

    movq $1, %rdi
    leaq -32(%rbp), %rsi
    glCall glGenBuffers

    movq $0x8892, %rdi # GL_ARRAY_BUFFER
    movl -32(%rbp), %esi
    glCall glBindBuffer

    movq $0x8892, %rdi # GL_ARRAY_BUFFER
    movq -16(%rbp), %rsi
    shl $2, %rsi # 4 * count of floats
    movq -8(%rbp), %rdx
    movq $0x88E4, %rcx # GL_STATIC_DRAW
    glCall glBufferData

    movq $0, %rdi
    movq $3, %rsi
    movq $0x1406, %rdx # GL_FLOAT
    movq $0, %rcx # GL_FALSE
    movq $0, %r8
    movq $0, %r9
    glCall glVertexAttribPointer

    movq $0x8892, %rdi # GL_ARRAY_BUFFER
    movq $0, %rsi
    glCall glBindBuffer

    movq $0, %rdi
    glCall glBindVertexArray

    movl -24(%rbp), %eax

    movq %rbp, %rsp
    popq %rbp
    ret

# (
#   %rdi = vposBuffer: float*
#   %rsi = vnormBuffer: float*
#   %rdx = count: i32
# ) -> vaoID: i32
ball_vao:
    pushq %rbp
    movq %rsp, %rbp

    # -8(%rbp) = vposBuffer (ptr, param)
    # -16(%rbp) = vnormBuffer (ptr, param)
    # -24(%rbp) = count (i32, param)
    # -32(%rbp) = vaoID (i32)
    # -40(%rbp) = vposVboID (i32)
    # -48(%rbp) = vnormVboID (i32)
    subq $48, %rsp
    movq %rdi, -8(%rbp)
    movq %rsi, -16(%rbp)
    movq %rdx, -24(%rbp)

    movq $1, %rdi
    leaq -32(%rbp), %rsi
    glCall glGenVertexArrays

    movl -32(%rbp), %edi
    glCall glBindVertexArray

    movq $1, %rdi
    leaq -40(%rbp), %rsi
    glCall glGenBuffers

    movq $0x8892, %rdi # GL_ARRAY_BUFFER
    movl -40(%rbp), %esi
    glCall glBindBuffer

    movq $0x8892, %rdi # GL_ARRAY_BUFFER
    movq -24(%rbp), %rsi
    shl $2, %rsi # 4 * count of floats
    movq -8(%rbp), %rdx
    movq $0x88E4, %rcx # GL_STATIC_DRAW
    glCall glBufferData

    movq $0, %rdi
    movq $3, %rsi
    movq $0x1406, %rdx # GL_FLOAT
    movq $0, %rcx # GL_FALSE
    movq $0, %r8
    movq $0, %r9
    glCall glVertexAttribPointer

    movq $1, %rdi
    leaq -48(%rbp), %rsi
    glCall glGenBuffers

    movq $0x8892, %rdi # GL_ARRAY_BUFFER
    movl -48(%rbp), %esi
    glCall glBindBuffer

    movq $0x8892, %rdi # GL_ARRAY_BUFFER
    movq -24(%rbp), %rsi
    shl $2, %rsi # 4 * count of floats
    movq -16(%rbp), %rdx
    movq $0x88E4, %rcx # GL_STATIC_DRAW
    glCall glBufferData

    movq $1, %rdi
    movq $3, %rsi
    movq $0x1406, %rdx # GL_FLOAT
    movq $0, %rcx # GL_FALSE
    movq $0, %r8
    movq $0, %r9
    glCall glVertexAttribPointer

    movq $0x8892, %rdi # GL_ARRAY_BUFFER
    movq $0, %rsi
    glCall glBindBuffer

    movq $0, %rdi
    glCall glBindVertexArray

    movl -32(%rbp), %eax

    movq %rbp, %rsp
    popq %rbp
    ret



.data


padVerticesPos:
.float -0.150000
.float -0.100000
.float 0.000000
.float 0.150000
.float -0.100000
.float 0.000000
.float -0.150000
.float 0.100000
.float 0.000000
.float -0.150000
.float 0.100000
.float 0.000000
.float 0.150000
.float -0.100000
.float 0.000000
.float 0.150000
.float 0.100000
.float 0.000000
cagePosBuffer:
.float -0.500000
.float 0.300000
.float -0.500000
.float 0.500000
.float 0.300000
.float -0.500000
.float 0.500000
.float 0.300000
.float -0.500000
.float 0.500000
.float -0.300000
.float -0.500000
.float 0.500000
.float -0.300000
.float -0.500000
.float -0.500000
.float -0.300000
.float -0.500000
.float -0.500000
.float -0.300000
.float -0.500000
.float -0.500000
.float 0.300000
.float -0.500000
.float -0.500000
.float 0.300000
.float -0.533333
.float 0.500000
.float 0.300000
.float -0.533333
.float 0.500000
.float 0.300000
.float -0.533333
.float 0.500000
.float -0.300000
.float -0.533333
.float 0.500000
.float -0.300000
.float -0.533333
.float -0.500000
.float -0.300000
.float -0.533333
.float -0.500000
.float -0.300000
.float -0.533333
.float -0.500000
.float 0.300000
.float -0.533333
.float -0.500000
.float 0.300000
.float -0.566667
.float 0.500000
.float 0.300000
.float -0.566667
.float 0.500000
.float 0.300000
.float -0.566667
.float 0.500000
.float -0.300000
.float -0.566667
.float 0.500000
.float -0.300000
.float -0.566667
.float -0.500000
.float -0.300000
.float -0.566667
.float -0.500000
.float -0.300000
.float -0.566667
.float -0.500000
.float 0.300000
.float -0.566667
.float -0.500000
.float 0.300000
.float -0.600000
.float 0.500000
.float 0.300000
.float -0.600000
.float 0.500000
.float 0.300000
.float -0.600000
.float 0.500000
.float -0.300000
.float -0.600000
.float 0.500000
.float -0.300000
.float -0.600000
.float -0.500000
.float -0.300000
.float -0.600000
.float -0.500000
.float -0.300000
.float -0.600000
.float -0.500000
.float 0.300000
.float -0.600000
.float -0.500000
.float 0.300000
.float -0.633333
.float 0.500000
.float 0.300000
.float -0.633333
.float 0.500000
.float 0.300000
.float -0.633333
.float 0.500000
.float -0.300000
.float -0.633333
.float 0.500000
.float -0.300000
.float -0.633333
.float -0.500000
.float -0.300000
.float -0.633333
.float -0.500000
.float -0.300000
.float -0.633333
.float -0.500000
.float 0.300000
.float -0.633333
.float -0.500000
.float 0.300000
.float -0.666667
.float 0.500000
.float 0.300000
.float -0.666667
.float 0.500000
.float 0.300000
.float -0.666667
.float 0.500000
.float -0.300000
.float -0.666667
.float 0.500000
.float -0.300000
.float -0.666667
.float -0.500000
.float -0.300000
.float -0.666667
.float -0.500000
.float -0.300000
.float -0.666667
.float -0.500000
.float 0.300000
.float -0.666667
.float -0.500000
.float 0.300000
.float -0.700000
.float 0.500000
.float 0.300000
.float -0.700000
.float 0.500000
.float 0.300000
.float -0.700000
.float 0.500000
.float -0.300000
.float -0.700000
.float 0.500000
.float -0.300000
.float -0.700000
.float -0.500000
.float -0.300000
.float -0.700000
.float -0.500000
.float -0.300000
.float -0.700000
.float -0.500000
.float 0.300000
.float -0.700000
.float -0.500000
.float 0.300000
.float -0.733333
.float 0.500000
.float 0.300000
.float -0.733333
.float 0.500000
.float 0.300000
.float -0.733333
.float 0.500000
.float -0.300000
.float -0.733333
.float 0.500000
.float -0.300000
.float -0.733333
.float -0.500000
.float -0.300000
.float -0.733333
.float -0.500000
.float -0.300000
.float -0.733333
.float -0.500000
.float 0.300000
.float -0.733333
.float -0.500000
.float 0.300000
.float -0.766667
.float 0.500000
.float 0.300000
.float -0.766667
.float 0.500000
.float 0.300000
.float -0.766667
.float 0.500000
.float -0.300000
.float -0.766667
.float 0.500000
.float -0.300000
.float -0.766667
.float -0.500000
.float -0.300000
.float -0.766667
.float -0.500000
.float -0.300000
.float -0.766667
.float -0.500000
.float 0.300000
.float -0.766667
.float -0.500000
.float 0.300000
.float -0.800000
.float 0.500000
.float 0.300000
.float -0.800000
.float 0.500000
.float 0.300000
.float -0.800000
.float 0.500000
.float -0.300000
.float -0.800000
.float 0.500000
.float -0.300000
.float -0.800000
.float -0.500000
.float -0.300000
.float -0.800000
.float -0.500000
.float -0.300000
.float -0.800000
.float -0.500000
.float 0.300000
.float -0.800000
.float -0.500000
.float 0.300000
.float -0.833333
.float 0.500000
.float 0.300000
.float -0.833333
.float 0.500000
.float 0.300000
.float -0.833333
.float 0.500000
.float -0.300000
.float -0.833333
.float 0.500000
.float -0.300000
.float -0.833333
.float -0.500000
.float -0.300000
.float -0.833333
.float -0.500000
.float -0.300000
.float -0.833333
.float -0.500000
.float 0.300000
.float -0.833333
.float -0.500000
.float 0.300000
.float -0.866667
.float 0.500000
.float 0.300000
.float -0.866667
.float 0.500000
.float 0.300000
.float -0.866667
.float 0.500000
.float -0.300000
.float -0.866667
.float 0.500000
.float -0.300000
.float -0.866667
.float -0.500000
.float -0.300000
.float -0.866667
.float -0.500000
.float -0.300000
.float -0.866667
.float -0.500000
.float 0.300000
.float -0.866667
.float -0.500000
.float 0.300000
.float -0.900000
.float 0.500000
.float 0.300000
.float -0.900000
.float 0.500000
.float 0.300000
.float -0.900000
.float 0.500000
.float -0.300000
.float -0.900000
.float 0.500000
.float -0.300000
.float -0.900000
.float -0.500000
.float -0.300000
.float -0.900000
.float -0.500000
.float -0.300000
.float -0.900000
.float -0.500000
.float 0.300000
.float -0.900000
.float -0.500000
.float 0.300000
.float -0.933333
.float 0.500000
.float 0.300000
.float -0.933333
.float 0.500000
.float 0.300000
.float -0.933333
.float 0.500000
.float -0.300000
.float -0.933333
.float 0.500000
.float -0.300000
.float -0.933333
.float -0.500000
.float -0.300000
.float -0.933333
.float -0.500000
.float -0.300000
.float -0.933333
.float -0.500000
.float 0.300000
.float -0.933333
.float -0.500000
.float 0.300000
.float -0.966667
.float 0.500000
.float 0.300000
.float -0.966667
.float 0.500000
.float 0.300000
.float -0.966667
.float 0.500000
.float -0.300000
.float -0.966667
.float 0.500000
.float -0.300000
.float -0.966667
.float -0.500000
.float -0.300000
.float -0.966667
.float -0.500000
.float -0.300000
.float -0.966667
.float -0.500000
.float 0.300000
.float -0.966667
.float -0.500000
.float 0.300000
.float -1.000000
.float 0.500000
.float 0.300000
.float -1.000000
.float 0.500000
.float 0.300000
.float -1.000000
.float 0.500000
.float -0.300000
.float -1.000000
.float 0.500000
.float -0.300000
.float -1.000000
.float -0.500000
.float -0.300000
.float -1.000000
.float -0.500000
.float -0.300000
.float -1.000000
.float -0.500000
.float 0.300000
.float -1.000000
.float -0.500000
.float 0.300000
.float -1.033333
.float 0.500000
.float 0.300000
.float -1.033333
.float 0.500000
.float 0.300000
.float -1.033333
.float 0.500000
.float -0.300000
.float -1.033333
.float 0.500000
.float -0.300000
.float -1.033333
.float -0.500000
.float -0.300000
.float -1.033333
.float -0.500000
.float -0.300000
.float -1.033333
.float -0.500000
.float 0.300000
.float -1.033333
.float -0.500000
.float 0.300000
.float -1.066667
.float 0.500000
.float 0.300000
.float -1.066667
.float 0.500000
.float 0.300000
.float -1.066667
.float 0.500000
.float -0.300000
.float -1.066667
.float 0.500000
.float -0.300000
.float -1.066667
.float -0.500000
.float -0.300000
.float -1.066667
.float -0.500000
.float -0.300000
.float -1.066667
.float -0.500000
.float 0.300000
.float -1.066667
.float -0.500000
.float 0.300000
.float -1.100000
.float 0.500000
.float 0.300000
.float -1.100000
.float 0.500000
.float 0.300000
.float -1.100000
.float 0.500000
.float -0.300000
.float -1.100000
.float 0.500000
.float -0.300000
.float -1.100000
.float -0.500000
.float -0.300000
.float -1.100000
.float -0.500000
.float -0.300000
.float -1.100000
.float -0.500000
.float 0.300000
.float -1.100000
.float -0.500000
.float 0.300000
.float -1.133333
.float 0.500000
.float 0.300000
.float -1.133333
.float 0.500000
.float 0.300000
.float -1.133333
.float 0.500000
.float -0.300000
.float -1.133333
.float 0.500000
.float -0.300000
.float -1.133333
.float -0.500000
.float -0.300000
.float -1.133333
.float -0.500000
.float -0.300000
.float -1.133333
.float -0.500000
.float 0.300000
.float -1.133333
.float -0.500000
.float 0.300000
.float -1.166667
.float 0.500000
.float 0.300000
.float -1.166667
.float 0.500000
.float 0.300000
.float -1.166667
.float 0.500000
.float -0.300000
.float -1.166667
.float 0.500000
.float -0.300000
.float -1.166667
.float -0.500000
.float -0.300000
.float -1.166667
.float -0.500000
.float -0.300000
.float -1.166667
.float -0.500000
.float 0.300000
.float -1.166667
.float -0.500000
.float 0.300000
.float -1.200000
.float 0.500000
.float 0.300000
.float -1.200000
.float 0.500000
.float 0.300000
.float -1.200000
.float 0.500000
.float -0.300000
.float -1.200000
.float 0.500000
.float -0.300000
.float -1.200000
.float -0.500000
.float -0.300000
.float -1.200000
.float -0.500000
.float -0.300000
.float -1.200000
.float -0.500000
.float 0.300000
.float -1.200000
.float -0.500000
.float 0.300000
.float -1.233333
.float 0.500000
.float 0.300000
.float -1.233333
.float 0.500000
.float 0.300000
.float -1.233333
.float 0.500000
.float -0.300000
.float -1.233333
.float 0.500000
.float -0.300000
.float -1.233333
.float -0.500000
.float -0.300000
.float -1.233333
.float -0.500000
.float -0.300000
.float -1.233333
.float -0.500000
.float 0.300000
.float -1.233333
.float -0.500000
.float 0.300000
.float -1.266667
.float 0.500000
.float 0.300000
.float -1.266667
.float 0.500000
.float 0.300000
.float -1.266667
.float 0.500000
.float -0.300000
.float -1.266667
.float 0.500000
.float -0.300000
.float -1.266667
.float -0.500000
.float -0.300000
.float -1.266667
.float -0.500000
.float -0.300000
.float -1.266667
.float -0.500000
.float 0.300000
.float -1.266667
.float -0.500000
.float 0.300000
.float -1.300000
.float 0.500000
.float 0.300000
.float -1.300000
.float 0.500000
.float 0.300000
.float -1.300000
.float 0.500000
.float -0.300000
.float -1.300000
.float 0.500000
.float -0.300000
.float -1.300000
.float -0.500000
.float -0.300000
.float -1.300000
.float -0.500000
.float -0.300000
.float -1.300000
.float -0.500000
.float 0.300000
.float -1.300000
.float -0.500000
.float 0.300000
.float -1.333333
.float 0.500000
.float 0.300000
.float -1.333333
.float 0.500000
.float 0.300000
.float -1.333333
.float 0.500000
.float -0.300000
.float -1.333333
.float 0.500000
.float -0.300000
.float -1.333333
.float -0.500000
.float -0.300000
.float -1.333333
.float -0.500000
.float -0.300000
.float -1.333333
.float -0.500000
.float 0.300000
.float -1.333333
.float -0.500000
.float 0.300000
.float -1.366667
.float 0.500000
.float 0.300000
.float -1.366667
.float 0.500000
.float 0.300000
.float -1.366667
.float 0.500000
.float -0.300000
.float -1.366667
.float 0.500000
.float -0.300000
.float -1.366667
.float -0.500000
.float -0.300000
.float -1.366667
.float -0.500000
.float -0.300000
.float -1.366667
.float -0.500000
.float 0.300000
.float -1.366667
.float -0.500000
.float 0.300000
.float -1.400000
.float 0.500000
.float 0.300000
.float -1.400000
.float 0.500000
.float 0.300000
.float -1.400000
.float 0.500000
.float -0.300000
.float -1.400000
.float 0.500000
.float -0.300000
.float -1.400000
.float -0.500000
.float -0.300000
.float -1.400000
.float -0.500000
.float -0.300000
.float -1.400000
.float -0.500000
.float 0.300000
.float -1.400000
.float -0.500000
.float 0.300000
.float -1.433333
.float 0.500000
.float 0.300000
.float -1.433333
.float 0.500000
.float 0.300000
.float -1.433333
.float 0.500000
.float -0.300000
.float -1.433333
.float 0.500000
.float -0.300000
.float -1.433333
.float -0.500000
.float -0.300000
.float -1.433333
.float -0.500000
.float -0.300000
.float -1.433333
.float -0.500000
.float 0.300000
.float -1.433333
.float -0.500000
.float 0.300000
.float -1.466667
.float 0.500000
.float 0.300000
.float -1.466667
.float 0.500000
.float 0.300000
.float -1.466667
.float 0.500000
.float -0.300000
.float -1.466667
.float 0.500000
.float -0.300000
.float -1.466667
.float -0.500000
.float -0.300000
.float -1.466667
.float -0.500000
.float -0.300000
.float -1.466667
.float -0.500000
.float 0.300000
.float -1.466667
.float -0.500000
.float 0.300000
.float -1.500000
.float 0.500000
.float 0.300000
.float -1.500000
.float 0.500000
.float 0.300000
.float -1.500000
.float 0.500000
.float -0.300000
.float -1.500000
.float 0.500000
.float -0.300000
.float -1.500000
.float -0.500000
.float -0.300000
.float -1.500000
.float -0.500000
.float -0.300000
.float -1.500000
.float -0.500000
.float 0.300000
.float -1.500000
.equ cagePosBufferSize, .-cagePosBuffer
.equ cageFloatsCount, 744
.equ cageVertexCountConst, 248

.globl cageVertexCount
cageVertexCount: .quad cageVertexCountConst
ballVpos:
.float -0.050000
.float 0.050000
.float 0.050000
.float -0.050000
.float -0.050000
.float 0.050000
.float 0.050000
.float 0.050000
.float 0.050000
.float 0.050000
.float 0.050000
.float 0.050000
.float -0.050000
.float -0.050000
.float 0.050000
.float 0.050000
.float -0.050000
.float 0.050000
.float 0.050000
.float 0.050000
.float -0.050000
.float 0.050000
.float 0.050000
.float 0.050000
.float 0.050000
.float -0.050000
.float 0.050000
.float 0.050000
.float 0.050000
.float -0.050000
.float 0.050000
.float -0.050000
.float 0.050000
.float 0.050000
.float -0.050000
.float -0.050000
.float -0.050000
.float 0.050000
.float -0.050000
.float -0.050000
.float 0.050000
.float 0.050000
.float 0.050000
.float 0.050000
.float 0.050000
.float -0.050000
.float 0.050000
.float -0.050000
.float 0.050000
.float 0.050000
.float 0.050000
.float 0.050000
.float 0.050000
.float -0.050000
.float -0.050000
.float 0.050000
.float -0.050000
.float -0.050000
.float -0.050000
.float -0.050000
.float -0.050000
.float 0.050000
.float 0.050000
.float -0.050000
.float 0.050000
.float 0.050000
.float -0.050000
.float -0.050000
.float -0.050000
.float -0.050000
.float -0.050000
.float 0.050000
.float -0.050000
.float -0.050000
.float -0.050000
.float -0.050000
.float -0.050000
.float 0.050000
.float 0.050000
.float -0.050000
.float 0.050000
.float -0.050000
.float -0.050000
.float -0.050000
.float 0.050000
.float -0.050000
.float 0.050000
.float 0.050000
.float -0.050000
.float -0.050000
ballNormals:
.float 0.000000
.float 0.000000
.float 1.000000
.float 0.000000
.float 0.000000
.float 1.000000
.float 0.000000
.float 0.000000
.float 1.000000
.float 0.000000
.float 0.000000
.float 1.000000
.float 0.000000
.float 0.000000
.float 1.000000
.float 0.000000
.float 0.000000
.float 1.000000
.float 1.000000
.float 0.000000
.float 0.000000
.float 1.000000
.float 0.000000
.float 0.000000
.float 1.000000
.float 0.000000
.float 0.000000
.float 1.000000
.float 0.000000
.float 0.000000
.float 1.000000
.float 0.000000
.float 0.000000
.float 1.000000
.float 0.000000
.float 0.000000
.float 0.000000
.float 1.000000
.float 0.000000
.float 0.000000
.float 1.000000
.float 0.000000
.float 0.000000
.float 1.000000
.float 0.000000
.float 0.000000
.float 1.000000
.float 0.000000
.float 0.000000
.float 1.000000
.float 0.000000
.float 0.000000
.float 1.000000
.float 0.000000
.float -1.000000
.float 0.000000
.float 0.000000
.float -1.000000
.float 0.000000
.float 0.000000
.float -1.000000
.float 0.000000
.float 0.000000
.float -1.000000
.float 0.000000
.float 0.000000
.float -1.000000
.float 0.000000
.float 0.000000
.float -1.000000
.float 0.000000
.float 0.000000
.float 0.000000
.float -1.000000
.float 0.000000
.float 0.000000
.float -1.000000
.float 0.000000
.float 0.000000
.float -1.000000
.float 0.000000
.float 0.000000
.float -1.000000
.float 0.000000
.float 0.000000
.float -1.000000
.float 0.000000
.float 0.000000
.float -1.000000
.float 0.000000
cageProjectorPos:
.float -0.500000
.float 0.300000
.float 0.000000
.float 0.500000
.float 0.300000
.float 0.000000
.float 0.500000
.float 0.300000
.float 0.000000
.float 0.500000
.float -0.300000
.float 0.000000
.float 0.500000
.float -0.300000
.float 0.000000
.float -0.500000
.float -0.300000
.float 0.000000
.float -0.500000
.float -0.300000
.float 0.000000
.float -0.500000
.float 0.300000
.float 0.000000
heartPos:
.float 0.000000
.float 0.000000
.float 0.000000
.float -0.009600
.float 0.040000
.float 0.000000
.float -0.024000
.float 0.028000
.float 0.000000
.float 0.000000
.float 0.000000
.float 0.000000
.float 0.000000
.float 0.036000
.float 0.000000
.float -0.009600
.float 0.040000
.float 0.000000
.float 0.000000
.float 0.000000
.float 0.000000
.float 0.009600
.float 0.040000
.float 0.000000
.float 0.000000
.float 0.036000
.float 0.000000
.float 0.000000
.float 0.000000
.float 0.000000
.float 0.024000
.float 0.028000
.float 0.000000
.float 0.009600
.float 0.040000
.float 0.000000
