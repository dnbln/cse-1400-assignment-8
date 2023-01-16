#include <glad/glad.h>

#define GLFW_INCLUDE_NONE

#include <GLFW/glfw3.h>

#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <stdbool.h>

#include "geimImpl.h"

#define GLSL_VERSION_LINE "#version 450 core\n"

static inline void dumpFloatBuffer(const char *name, const float *buf, const size_t num) {
//    printf("%s:\n", name);
//    for (size_t i = 0; i < num; i++)
//        printf(".float %f\n", buf[i]);
}

static const struct {
    float x, y, z;
} padVerticesPos[6] =
        {
                {-PAD_WIDTH, -PAD_HEIGHT, 0.f},
                {PAD_WIDTH,  -PAD_HEIGHT, 0.f},
                {-PAD_WIDTH, PAD_HEIGHT,  0.f},
                {-PAD_WIDTH, PAD_HEIGHT,  0.f},
                {PAD_WIDTH,  -PAD_HEIGHT, 0.f},
                {PAD_WIDTH,  PAD_HEIGHT,  0.f}
        };

static GLuint padVAO() {
    GLuint padVaoID;
    glGenVertexArrays(1, &padVaoID);
    glBindVertexArray(padVaoID);

    GLuint quadVposBuffer;
    glGenBuffers(1, &quadVposBuffer);

    glBindBuffer(GL_ARRAY_BUFFER, quadVposBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(float) * 6 * 3, &padVerticesPos[0].x, GL_STATIC_DRAW);
    dumpFloatBuffer("padVerticesPos", &padVerticesPos[0].x, 6 * 3);

    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, 0);

    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);

    return padVaoID;
}

static const struct {
    float x, y, z;
} ballsNormals[30] =
        {
                //front
                {0,  0,  1},
                {0,  0,  1},
                {0,  0,  1},
                {0,  0,  1},
                {0,  0,  1},
                {0,  0,  1},
                //right
                {1,  0,  0},
                {1,  0,  0},
                {1,  0,  0},
                {1,  0,  0},
                {1,  0,  0},
                {1,  0,  0},
                //upside
                {0,  1,  0},
                {0,  1,  0},
                {0,  1,  0},
                {0,  1,  0},
                {0,  1,  0},
                {0,  1,  0},
                //leftside
                {-1, 0,  0},
                {-1, 0,  0},
                {-1, 0,  0},
                {-1, 0,  0},
                {-1, 0,  0},
                {-1, 0,  0},
                //bottomside
                {0,  -1, 0},
                {0,  -1, 0},
                {0,  -1, 0},
                {0,  -1, 0},
                {0,  -1, 0},
                {0,  -1, 0}
        };

static const struct {
    float x, y, z;
} balls[30] =
        {
                //front
                {-BALL_RADIUS, BALL_RADIUS,  BALL_RADIUS},
                {-BALL_RADIUS, -BALL_RADIUS, BALL_RADIUS},
                {BALL_RADIUS,  BALL_RADIUS,  BALL_RADIUS},
                {BALL_RADIUS,  BALL_RADIUS,  BALL_RADIUS},
                {-BALL_RADIUS, -BALL_RADIUS, BALL_RADIUS},
                {BALL_RADIUS,  -BALL_RADIUS, BALL_RADIUS},
                //right
                {BALL_RADIUS,  BALL_RADIUS,  -BALL_RADIUS},
                {BALL_RADIUS,  BALL_RADIUS,  BALL_RADIUS},
                {BALL_RADIUS,  -BALL_RADIUS, BALL_RADIUS},
                {BALL_RADIUS,  BALL_RADIUS,  -BALL_RADIUS},
                {BALL_RADIUS,  -BALL_RADIUS, BALL_RADIUS},
                {BALL_RADIUS,  -BALL_RADIUS, -BALL_RADIUS},
                //upside
                {-BALL_RADIUS, BALL_RADIUS,  -BALL_RADIUS},
                {-BALL_RADIUS, BALL_RADIUS,  BALL_RADIUS},
                {BALL_RADIUS,  BALL_RADIUS,  BALL_RADIUS},
                {-BALL_RADIUS, BALL_RADIUS,  -BALL_RADIUS},
                {BALL_RADIUS,  BALL_RADIUS,  BALL_RADIUS},
                {BALL_RADIUS,  BALL_RADIUS,  -BALL_RADIUS},
                //leftside
                {-BALL_RADIUS, BALL_RADIUS,  -BALL_RADIUS},
                {-BALL_RADIUS, -BALL_RADIUS, -BALL_RADIUS},
                {-BALL_RADIUS, BALL_RADIUS,  BALL_RADIUS},
                {-BALL_RADIUS, BALL_RADIUS,  BALL_RADIUS},
                {-BALL_RADIUS, -BALL_RADIUS, -BALL_RADIUS},
                {-BALL_RADIUS, -BALL_RADIUS, BALL_RADIUS},
                //bottomside
                {-BALL_RADIUS, -BALL_RADIUS, -BALL_RADIUS},
                {-BALL_RADIUS, -BALL_RADIUS, BALL_RADIUS},
                {BALL_RADIUS,  -BALL_RADIUS, BALL_RADIUS},
                {-BALL_RADIUS, -BALL_RADIUS, -BALL_RADIUS},
                {BALL_RADIUS,  -BALL_RADIUS, BALL_RADIUS},
                {BALL_RADIUS,  -BALL_RADIUS, -BALL_RADIUS}
        };


static GLuint ballVAO() {
    GLuint ballVaoID;
    glGenVertexArrays(1, &ballVaoID);
    glBindVertexArray(ballVaoID);

    GLuint ballVposVBO;
    glGenBuffers(1, &ballVposVBO);

    glBindBuffer(GL_ARRAY_BUFFER, ballVposVBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(float) * 30 * 3, &balls[0].x, GL_STATIC_DRAW);

    dumpFloatBuffer("ballVpos", &balls[0].x, 30 * 3);

    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, 0);

    GLuint ballVnormVBO;
    glGenBuffers(1, &ballVnormVBO);

    glBindBuffer(GL_ARRAY_BUFFER, ballVnormVBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(float) * 30 * 3, &ballsNormals[0].x, GL_STATIC_DRAW);

    dumpFloatBuffer("ballNormals", &ballsNormals[0].x, 30 * 3);

    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 0, 0);

    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);

    return ballVaoID;
}

static int cageVertexCount;

static GLuint cageVAO() {
    GLuint vaoID;

    glGenVertexArrays(1, &vaoID);
    glBindVertexArray(vaoID);

    GLuint vposBuffer;
    glGenBuffers(1, &vposBuffer);

    glBindBuffer(GL_ARRAY_BUFFER, vposBuffer);

    float buffer[3 * 1234];
    int k = 0;

#define CAGE_DEPTH_STRIPES 30
    for (int depth = 0; depth <= CAGE_DEPTH_STRIPES; depth++) {
        float z = CAGE_START_DEPTH - ((float) depth) / CAGE_DEPTH_STRIPES * CAGE_DEPTH;

        // top line
        buffer[k++] = -CAGE_WIDTH;
        buffer[k++] = CAGE_HEIGHT;
        buffer[k++] = z;

        buffer[k++] = CAGE_WIDTH;
        buffer[k++] = CAGE_HEIGHT;
        buffer[k++] = z;

        // right line
        buffer[k++] = CAGE_WIDTH;
        buffer[k++] = CAGE_HEIGHT;
        buffer[k++] = z;

        buffer[k++] = CAGE_WIDTH;
        buffer[k++] = -CAGE_HEIGHT;
        buffer[k++] = z;

        // bottom line
        buffer[k++] = CAGE_WIDTH;
        buffer[k++] = -CAGE_HEIGHT;
        buffer[k++] = z;

        buffer[k++] = -CAGE_WIDTH;
        buffer[k++] = -CAGE_HEIGHT;
        buffer[k++] = z;

        // left line
        buffer[k++] = -CAGE_WIDTH;
        buffer[k++] = -CAGE_HEIGHT;
        buffer[k++] = z;

        buffer[k++] = -CAGE_WIDTH;
        buffer[k++] = CAGE_HEIGHT;
        buffer[k++] = z;
    }

    glBufferData(GL_ARRAY_BUFFER, sizeof(float) * k, buffer, GL_STATIC_DRAW);
    dumpFloatBuffer("cagePosBuffer", buffer, k);

    printf(".equ cagePosBufferSize, .-cagePosBuffer\n");
    printf(".equ cageFloatsCount, %d\n", k);
    printf(".equ cageVertexCountConst, %d\n", k / 3);
    printf(".globl cageVertexCount\n"
           "cageVertexCount: .quad cageVertexCountConst\n");

    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, 0);

    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);

    cageVertexCount = k / 3; // 3 floats / vertex

    return vaoID;
}

static GLuint cageProjectorVAO() {
    GLuint vaoID;

    glGenVertexArrays(1, &vaoID);
    glBindVertexArray(vaoID);

    GLuint vposBuffer;
    glGenBuffers(1, &vposBuffer);

    glBindBuffer(GL_ARRAY_BUFFER, vposBuffer);

    float buffer[24];

    // top line
    buffer[0] = -CAGE_WIDTH;
    buffer[1] = CAGE_HEIGHT;
    buffer[2] = 0;

    buffer[3] = CAGE_WIDTH;
    buffer[4] = CAGE_HEIGHT;
    buffer[5] = 0;

    // right line
    buffer[6] = CAGE_WIDTH;
    buffer[7] = CAGE_HEIGHT;
    buffer[8] = 0;

    buffer[9] = CAGE_WIDTH;
    buffer[10] = -CAGE_HEIGHT;
    buffer[11] = 0;

    // bottom line
    buffer[12] = CAGE_WIDTH;
    buffer[13] = -CAGE_HEIGHT;
    buffer[14] = 0;

    buffer[15] = -CAGE_WIDTH;
    buffer[16] = -CAGE_HEIGHT;
    buffer[17] = 0;

    // left line
    buffer[18] = -CAGE_WIDTH;
    buffer[19] = -CAGE_HEIGHT;
    buffer[20] = 0;

    buffer[21] = -CAGE_WIDTH;
    buffer[22] = CAGE_HEIGHT;
    buffer[23] = 0;

    glBufferData(GL_ARRAY_BUFFER, sizeof(float) * 24, buffer, GL_STATIC_DRAW);
    dumpFloatBuffer("cageProjectorPos", buffer, 24);

    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, 0);

    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);

    return vaoID;
}

static GLuint heartVAO() {
    GLuint vaoID;

    glGenVertexArrays(1, &vaoID);
    glBindVertexArray(vaoID);

    GLuint vposBuffer;
    glGenBuffers(1, &vposBuffer);

    glBindBuffer(GL_ARRAY_BUFFER, vposBuffer);

    float buffer[36];

#define HEART_HEIGHT 0.04f
#define HEART_WIDTH 0.024f
#define UP_CENTER_X_SCALE 0.4f
#define UP_CENTER_Y_SCALE 0.9f
#define HEART_CENTER_Y_SCALE 0.7f

    // left triangle
    // center-bottom dot
    buffer[0] = 0;
    buffer[1] = 0;
    buffer[2] = 0;

    // top-left dot
    buffer[3] = -HEART_WIDTH * UP_CENTER_X_SCALE;
    buffer[4] = HEART_HEIGHT;
    buffer[5] = 0;

    // left dot
    buffer[6] = -HEART_WIDTH;
    buffer[7] = HEART_HEIGHT * HEART_CENTER_Y_SCALE;
    buffer[8] = 0;


    // middle left triangle

    // center-bottom dot
    buffer[9] = 0;
    buffer[10] = 0;
    buffer[11] = 0;

    // top dot
    buffer[12] = 0;
    buffer[13] = HEART_HEIGHT * UP_CENTER_Y_SCALE;
    buffer[14] = 0;


    buffer[15] = -HEART_WIDTH * UP_CENTER_X_SCALE;
    buffer[16] = HEART_HEIGHT;
    buffer[17] = 0;


    // middle right triangle

    // center-bt
    buffer[18] = 0;
    buffer[19] = 0;
    buffer[20] = 0;

    //centerbottom dot
    buffer[21] = HEART_WIDTH * UP_CENTER_X_SCALE;
    buffer[22] = HEART_HEIGHT;
    buffer[23] = 0;


    buffer[24] = 0;
    buffer[25] = HEART_HEIGHT * UP_CENTER_Y_SCALE;
    buffer[26] = 0;

    // right triangle
    // center-bottom dot
    buffer[27] = 0;
    buffer[28] = 0;
    buffer[29] = 0;

    // left dot
    buffer[30] = HEART_WIDTH;
    buffer[31] = HEART_HEIGHT * HEART_CENTER_Y_SCALE;
    buffer[32] = 0;

    // top-left dot
    buffer[33] = HEART_WIDTH * UP_CENTER_X_SCALE;
    buffer[34] = HEART_HEIGHT;
    buffer[35] = 0;

    glBufferData(GL_ARRAY_BUFFER, sizeof(float) * 36, buffer, GL_STATIC_DRAW);
    dumpFloatBuffer("heartPos", buffer, 36);

    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, 0);

    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);

    return vaoID;
}

static GLuint compile_shader(const char *vertex, const char *fragment) {
    GLuint vertex_shader, fragment_shader, program;

    vertex_shader = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertex_shader, 1, &vertex, NULL);
    glCompileShader(vertex_shader);

    fragment_shader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragment_shader, 1, &fragment, NULL);
    glCompileShader(fragment_shader);

    program = glCreateProgram();
    glAttachShader(program, vertex_shader);
    glAttachShader(program, fragment_shader);
    glLinkProgram(program);

    glDeleteShader(vertex_shader);
    glDeleteShader(fragment_shader);

    return program;
}

float perspectiveMatrix[16];

float *loadPerspectiveMatrix(int width, int height, float fov, float near, float far) {
    float aspect = ((float) width) / (float) height;
    float tanFov2 = tanf(fov * 3.14159265359f / 180.0f / 2.0f);


//    float *buffer = malloc(16 * sizeof (float));
    float *buffer = perspectiveMatrix;

    // matrices in OpenGL are column-major, so that means that we store all the elements in the first column, then all
    // the elements in the 2nd column, then the 3rd and then the 4th

    // first column
    buffer[0] = 1.0f / (aspect * tanFov2);
    buffer[1] = 0;
    buffer[2] = 0;
    buffer[3] = 0;

    // second column
    buffer[4] = 0;
    buffer[5] = 1 / tanFov2;
    buffer[6] = 0;
    buffer[7] = 0;

    // third column
    buffer[8] = 0;
    buffer[9] = 0;
    buffer[10] = -((far + near) / (far - near));
    buffer[11] = -1;

    // fourth column
    buffer[12] = 0;
    buffer[13] = 0;
    buffer[14] = -(2 * far * near / (far - near));
    buffer[15] = 0;

    return buffer;
}

static void error_callback(int error, const char *description) {
    printf("Error: %s\n", description);
}

static void key_callback(GLFWwindow *window, int key, int scancode, int action, int mods) {
    if (key == GLFW_KEY_ESCAPE && action == GLFW_PRESS)
        glfwSetWindowShouldClose(window, GLFW_TRUE);
}

#define WINDOW_WIDTH 1440
#define WINDOW_HEIGHT 720
static float mouseXpos, mouseYpos;

void mousePosCallback(GLFWwindow *window, double xpos, double ypos) {
    mouseXpos = (float) xpos;
    mouseYpos = (float) ypos;
}

void mouseControlPadFun(struct Pad *self, struct Ball *_ball) {
#define MOUSE_X_SCALING 1.4f
    self->x = ((mouseXpos / WINDOW_WIDTH) * MOUSE_X_SCALING - (MOUSE_X_SCALING / 2));
#define MOUSE_Y_SCALING 0.73f
    self->y = -((mouseYpos / WINDOW_HEIGHT) * MOUSE_Y_SCALING - (MOUSE_Y_SCALING / 2));
}

void unbeatableControlPadFun(struct Pad *self, struct Ball *ball) {
    self->x = ball->x;
    self->y = ball->y;
}

void beatableControlPadFun(struct Pad *self, struct Ball *ball) {
    if (ball->dirZ < 0) {
//        self->x = self->x + ball->dirX * 0.8f;
//        self->y = self->y + ball->dirY * 0.8f;
        self->x = self->x + ball->dirX;
        self->y = self->y + ball->dirY;
    } else {
        self->x = self->x + (0 - self->x) * 0.03f;
        self->y = self->y + (0 - self->y) * 0.03f;
    }
}

float transformationMatrix[16];

float *makeTransformationMatrix(float translateX, float translateY, float translateZ) {
    float *buffer = transformationMatrix;

    // 1st column
    buffer[0] = 1;
    buffer[1] = 0;
    buffer[2] = 0;
    buffer[3] = 0;

    // 2nd column
    buffer[4] = 0;
    buffer[5] = 1;
    buffer[6] = 0;
    buffer[7] = 0;

    // 3rd column
    buffer[8] = 0;
    buffer[9] = 0;
    buffer[10] = 1;
    buffer[11] = 0;

    // 4th column
    buffer[12] = translateX;
    buffer[13] = translateY;
    buffer[14] = translateZ;
    buffer[15] = 1;

    return buffer;
}

static GLFWwindow *geim_init() {
    GLFWwindow *window;
    glfwSetErrorCallback(error_callback);

    if (!glfwInit())
        exit(EXIT_FAILURE);

    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 4);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 5);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
    glfwWindowHint(GLFW_RESIZABLE, GLFW_FALSE);

    window = glfwCreateWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Simple example", NULL, NULL);
    if (!window) {
        glfwTerminate();
        exit(EXIT_FAILURE);
    }

    glfwSetKeyCallback(window, key_callback);
    glfwSetCursorPosCallback(window, mousePosCallback);

    glfwMakeContextCurrent(window);
    gladLoadGLLoader((GLADloadproc) glfwGetProcAddress);
    glfwSwapInterval(1);

    return window;
}

void restoreState(struct GameState *state, struct Pad *padOne, struct Pad *padTwo, struct Ball *ball) {
    padOne->x = padOne->y = 0;
    padTwo->x = padTwo->y = 0;

    ball->x = ball->y = 0;
    ball->z = CAGE_START_DEPTH - CAGE_DEPTH / 2;

    ball->dirX = BALL_INIT_DIR_X;
    ball->dirY = BALL_INIT_DIR_Y;
    ball->dirZ = BALL_INIT_DIR_Z;
}

void padOneLost(struct GameState *state, struct Pad *padOne, struct Pad *padTwo, struct Ball *ball) {
    state->heartsPadOne--;

    if (state->heartsPadOne == 0)
        state->gameEnded = 1;
    else
        restoreState(state, padOne, padTwo, ball);
}

void padTwoLost(struct GameState *state, struct Pad *padOne, struct Pad *padTwo, struct Ball *ball) {
    state->heartsPadTwo--;

    if (state->heartsPadTwo == 0)
        state->gameEnded = 1;
    else
        restoreState(state, padOne, padTwo, ball);
}

int main(void) {
    GLFWwindow *window = geim_init();
    GLuint padProgram = compile_shader(
            // vertex.glsl
            GLSL_VERSION_LINE
            "layout (location = 0) in vec3 vPos;\n"
            "uniform mat4 projection;\n"
            "uniform mat4 transformation;\n"
            "void main()\n"
            "{\n"
            "    gl_Position = projection * transformation * vec4(vPos, 1.0);\n"
            "}\n",
            // fragment.glsl
            GLSL_VERSION_LINE
            "out vec4 FragColor;\n"
            "\n"
            "uniform vec3 padColor;\n"
            "void main()\n"
            "{\n"
            "    FragColor = vec4(padColor, 1.0);\n"
            "}\n"
    );

    GLuint padProjMatrixUniformID = glGetUniformLocation(padProgram, "projection"),
            padTransformationUniformID = glGetUniformLocation(padProgram, "transformation"),
            padColorUniformID = glGetUniformLocation(padProgram, "padColor");


    GLuint padVAOID = padVAO();

    GLuint cageProgram = compile_shader(
            // vertex.glsl
            GLSL_VERSION_LINE
            "layout (location = 0) in vec3 vPos;\n"
            "uniform mat4 projection;\n"
            "void main()\n"
            "{\n"
            "    gl_Position = projection * vec4(vPos, 1.0);\n"
            "}\n",
            // fragment.glsl
            GLSL_VERSION_LINE
            "out vec4 FragColor;\n"
            "\n"
            "void main()\n"
            "{\n"
            "    FragColor = vec4(0.25, 0.99, 1.0, 1.0);\n"
            "}\n"
    );

    GLuint cageProgramProjectionUniformID = glGetUniformLocation(cageProgram, "projection");

    GLuint cageVAOID = cageVAO();

    GLuint ballProgram = compile_shader(
            // vertex.glsl
            GLSL_VERSION_LINE
            "layout (location = 0) in vec3 vPos;\n"
            "layout (location = 1) in vec3 vNorm;\n"
            "layout (location = 0) out vec3 fragNorm;\n"
            "uniform mat4 transformation;\n"
            "uniform mat4 projection;\n"
            "void main()\n"
            "{\n"
            "    gl_Position = projection * transformation * vec4(vPos, 1.0);\n"
            "    fragNorm = vNorm;\n"
            "}\n",
            // fragment.glsl
            GLSL_VERSION_LINE
            "layout (location = 0) in vec3 fragNorm;"
            "out vec4 FragColor;\n"
            "\n"
            "void main()\n"
            "{\n"
            "    vec3 lightVector = normalize(vec3(-1, 1, 1));\n"
            "    float diffuseLighting = dot(lightVector, fragNorm) * 0.3 + 0.5;\n"
            "    vec3 color = vec3(1.0, 1.0, 1.0) * diffuseLighting;\n"
            "    FragColor = vec4(color, 1.0);\n"
            "}\n"
    );

    GLuint ballTransformationUniformID = glGetUniformLocation(ballProgram, "transformation"),
            ballProjectionUniformID = glGetUniformLocation(ballProgram, "projection");

    GLuint ballVAOID = ballVAO();

    GLuint cageProjectorProgram = compile_shader(
            // vertex.glsl
            GLSL_VERSION_LINE
            "layout (location = 0) in vec3 vPos;\n"
            "uniform mat4 projection;\n"
            "uniform float z;\n"
            "void main()\n"
            "{\n"
            "    gl_Position = projection * vec4(vPos.xy, vPos.z + z, 1.0);\n"
            "}\n",
            // fragment.glsl
            GLSL_VERSION_LINE
            "out vec4 FragColor;\n"
            "\n"
            "void main()\n"
            "{\n"
            "    FragColor = vec4(1.0, 1.0, 1.0, 1.0);\n"
            "}\n"
    );

    GLuint cageProjectorProjectionUniformID = glGetUniformLocation(cageProjectorProgram, "projection"),
            cageProjectorZUniformID = glGetUniformLocation(cageProjectorProgram, "z");

    GLuint projectorVAOID = cageProjectorVAO();

    GLuint heartShaderProgram = compile_shader(
            // vertex.glsl
            GLSL_VERSION_LINE
            "layout (location = 0) in vec3 vPos;\n"
            "uniform mat4 projection;\n"
            "uniform mat4 transform;\n"
            "void main()\n"
            "{\n"
            "    gl_Position = projection * transform * vec4(vPos, 1.0);\n"
            "}\n",
            // fragment.glsl
            GLSL_VERSION_LINE
            "out vec4 FragColor;\n"
            "uniform vec3 heartColor;\n"
            "\n"
            "void main()\n"
            "{\n"
            "    FragColor = vec4(heartColor, 1.0);\n"
            "}\n"
    );

    GLuint heartShaderProjectionUniformID = glGetUniformLocation(heartShaderProgram, "projection"),
            heartShaderTransformUniformID = glGetUniformLocation(heartShaderProgram, "transform"),
            heartShaderColorUniformID = glGetUniformLocation(heartShaderProgram, "heartColor");

    GLuint heartVAOID = heartVAO();


    int width, height;

    glfwGetFramebufferSize(window, &width, &height);

    glViewport(0, 0, width, height);

    float *perspectiveMatrix = loadPerspectiveMatrix(width, height, 70, 0.1f, 4.0f);

    struct Pad padone = {.x = 0, .y = 0, .z = CAGE_START_DEPTH, .controller_func = mouseControlPadFun},
            padtwo = {.x = 0, .y = 0, .z = CAGE_START_DEPTH - CAGE_DEPTH, .controller_func = beatableControlPadFun};

    struct Ball ball = {
            .x = 0,
            .y = 0,
            .z = CAGE_START_DEPTH - CAGE_DEPTH / 2,
            .dirX = BALL_INIT_DIR_X, .dirY = BALL_INIT_DIR_Y, .dirZ = BALL_INIT_DIR_Z};

    dumpFloatBuffer("padOneBuf", &padone.x, 3);
    dumpFloatBuffer("padTwoBuf", &padtwo.x, 3);
    dumpFloatBuffer("ballBuf", &ball.x, 6);

    glClearDepth(1.0f);
    glEnable(GL_DEPTH_TEST);
    glDepthFunc(GL_LEQUAL);
    glDepthRange(0, 1);

    struct GameState state = {.heartsPadOne = 3, .heartsPadTwo = 3, .controller_padone_lost = padOneLost, .controller_padtwo_lost = padTwoLost, .gameEnded = 0};

    while (!glfwWindowShouldClose(window)) {
        {
            glClearColor(0, 0, 0, 1);
            glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);
        }

        if (!state.gameEnded)
            logic(&state, &padone, &padtwo, &ball);

        {
            glBindVertexArray(cageVAOID);
            glEnableVertexAttribArray(0);

            glUseProgram(cageProgram);
            glUniformMatrix4fv(cageProgramProjectionUniformID, 1, GL_FALSE, perspectiveMatrix);
            glDrawArrays(GL_LINES, 0, cageVertexCount);

            glDisableVertexAttribArray(0);

            glBindVertexArray(0);
        }

        {
            glBindVertexArray(projectorVAOID);
            glEnableVertexAttribArray(0);

            glUseProgram(cageProjectorProgram);
            glUniformMatrix4fv(cageProjectorProjectionUniformID, 1, GL_FALSE, perspectiveMatrix);
            glUniform1f(cageProjectorZUniformID, ball.z);
            glDrawArrays(GL_LINES, 0, 8);

            glDisableVertexAttribArray(0);

            glBindVertexArray(0);
        }


        {
            glBindVertexArray(padVAOID);
            glEnableVertexAttribArray(0);

            glUseProgram(padProgram);

            glUniformMatrix4fv(padProjMatrixUniformID, 1, GL_FALSE, perspectiveMatrix);
            glUniformMatrix4fv(padTransformationUniformID, 1, GL_FALSE,
                               makeTransformationMatrix(padtwo.x, padtwo.y, padtwo.z));
            glUniform3f(padColorUniformID, 0.63f, 0.0f, 0.0f);

            glDrawArrays(GL_TRIANGLES, 0, 6);

            glUniformMatrix4fv(padTransformationUniformID, 1, GL_FALSE,
                               makeTransformationMatrix(padone.x, padone.y, padone.z));
            glUniform3f(padColorUniformID, 0.12f, 0.69f, 0.26f);

            glDrawArrays(GL_TRIANGLES, 0, 6);

            glDisableVertexAttribArray(0);

            glBindVertexArray(0);
        }

        {
            glBindVertexArray(ballVAOID);
            glEnableVertexAttribArray(0);
            glEnableVertexAttribArray(1);

            glUseProgram(ballProgram);

            glUniformMatrix4fv(ballProjectionUniformID, 1, GL_FALSE, perspectiveMatrix);
            glUniformMatrix4fv(ballTransformationUniformID, 1, GL_FALSE,
                               makeTransformationMatrix(ball.x, ball.y, ball.z));

            glDrawArrays(GL_TRIANGLES, 0, 30);

            glDisableVertexAttribArray(0);
            glDisableVertexAttribArray(1);

            glBindVertexArray(0);
        }

        {
            glBindVertexArray(heartVAOID);
            glEnableVertexAttribArray(0);

            glUseProgram(heartShaderProgram);
            glUniformMatrix4fv(heartShaderProjectionUniformID, 1, GL_FALSE, perspectiveMatrix);

#define HEART_OFFX 0.05f
#define HEART_OFFY 0.04f

            int heartsPadOneToRender = state.heartsPadOne;
            int heartsPadTwoToRender = state.heartsPadTwo;

            if (heartsPadTwoToRender == 0) {
                heartsPadTwoToRender = 3;
                glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
            }

            for (int i = 0; i < heartsPadTwoToRender; i++) {
                float x = -CAGE_WIDTH - 3 * HEART_OFFX + i * HEART_OFFX;
                float y = -CAGE_HEIGHT + 3 * HEART_OFFY;
                float z = CAGE_START_DEPTH;

                glUniformMatrix4fv(heartShaderTransformUniformID, 1, GL_FALSE, makeTransformationMatrix(x, y, z));
                glUniform3f(heartShaderColorUniformID, 0.63f, 0.0f, 0.0f);
                glDrawArrays(GL_TRIANGLES, 0, 36);
            }

            if (heartsPadOneToRender == 0) {
                heartsPadOneToRender = 3;
                glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
            } else {
                glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
            }

            for (int i = 0; i < heartsPadOneToRender; i++) {
                float x = -CAGE_WIDTH - 3 * HEART_OFFX + i * HEART_OFFX;
                float y = -CAGE_HEIGHT + 1 * HEART_OFFY;
                float z = CAGE_START_DEPTH;

                glUniformMatrix4fv(heartShaderTransformUniformID, 1, GL_FALSE, makeTransformationMatrix(x, y, z));
                glUniform3f(heartShaderColorUniformID, 0.12f, 0.69f, 0.26f);
                glDrawArrays(GL_TRIANGLES, 0, 36);
            }

            glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);

            glDisableVertexAttribArray(0);

            glBindVertexArray(0);
        }


        glfwSwapBuffers(window);
        glfwPollEvents();
    }

    glfwDestroyWindow(window);

    glfwTerminate();
    exit(EXIT_SUCCESS);
}