//
// Created by QWERTY on 10/21/2022.
//

#ifndef GEIM_GEIMIMPL_H
#define GEIM_GEIMIMPL_H

#define PAD_WIDTH 0.15f
#define PAD_HEIGHT 0.1f

#define BALL_RADIUS 0.05f

#define CAGE_WIDTH 0.5f
#define CAGE_HEIGHT 0.3f
#define CAGE_DEPTH 1.0f
#define BALL_SPEED 0.009f
#define BALL_PAD_INERTIA_FACTOR 0.1f

#define BALL_INIT_DIR_X BALL_SPEED
#define BALL_INIT_DIR_Y BALL_SPEED
#define BALL_INIT_DIR_Z BALL_SPEED

#define CAGE_START_DEPTH (-0.5f)

struct Ball {
    float x;
    float y;
    float z;

    float dirX;
    float dirY;
    float dirZ;
};

struct Pad {
    float x;
    float y;

    const float z;

    float deltaX;
    float deltaY;

    void (*controller_func)(struct Pad* self, struct Ball* ball);
};

struct GameState {
    int heartsPadOne;
    int heartsPadTwo;

    void (*controller_padone_lost)(struct GameState* self, struct Pad* padOne, struct Pad* padTwo, struct Ball* ball);
    void (*controller_padtwo_lost)(struct GameState* self, struct Pad* padOne, struct Pad* padTwo, struct Ball* ball);

    int gameEnded; // bool
};

void logic(struct GameState* state, struct Pad* padOne, struct Pad* padTwo, struct Ball* ball);

#endif //GEIM_GEIMIMPL_H
