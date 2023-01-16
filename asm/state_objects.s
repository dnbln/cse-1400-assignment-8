.bss
// struct Pad {
//      float x; // off = 0..4
//      float y; // off = 4..8
//      float z; // off = 8..12
//      float deltaX; // off = 12..16
//      float deltaY; // off = 16..20
//      float __padding; // off = 20..24
//      void (*controller_fun)(Pad* self, Ball* ball); // off = 24..32
// } // sizeof = 32

.globl padone
.lcomm padone, 32 # type = struct Pad
.globl padtwo
.lcomm padtwo, 32 # type = struct Pad


// struct Ball {
//      float x; // off = 0..4
//      float y; // off = 4..8
//      float z; // off = 8..12
//      float dirX; // off = 12..16
//      float dirY; // off = 16..20
//      float dirZ; // off = 20..24
// } // sizeof = 24
.globl ball
.lcomm ball, 24 # type = struct Ball

// struct GameState {
//     int heartsOne; // off = 0..4
//     int heartsTwo; // off = 4..8
//     int gameEnded; // off = 8..12
//     int __pad; // off = 12..16
//     void (*padOneLost)(GameState* self, Pad* padOne, Pad* padTwo, Ball* ball); // off = 16..24
//     void (*padTwoLost)(GameState* self, Pad* padOne, Pad* padTwo, Ball* ball); // off = 24..32
// } // sizeof = 32
.globl gameState
.lcomm gameState, 32 # type = struct GameState

.text

.globl init_game_state
init_game_state:
    pushq %rbp
    movq %rsp, %rbp

    movq $padone, %rdi
    movq $padOneBuf, %rsi
    movq $(3*4), %rdx
    call memcpy

    movq $padtwo, %rdi
    movq $padTwoBuf, %rsi
    movq $(3*4), %rdx
    call memcpy

    movq $ball, %rdi
    movq $ballBuf, %rsi
    movq $(6*4), %rdx
    call memcpy

    movq %rbp, %rsp
    popq %rbp
    retq


.globl reinit_game_state
reinit_game_state:
    jmp init_game_state

.data
padOneBuf:
.float 0.000000
.float 0.000000
.float -0.500000
padTwoBuf:
.float 0.000000
.float 0.000000
.float -1.500000
ballBuf:
.float 0.000000
.float 0.000000
.float -1.00000
.float 0.009000
.float 0.009000
.float 0.009000