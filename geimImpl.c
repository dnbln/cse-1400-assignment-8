//
// Created by QWERTY on 10/21/2022.
//

#include <stdbool.h>
#include <math.h>
#include "geimImpl.h"

static bool inPadRange(struct Pad *pad, struct Ball *ball) {
//    if (pad->x + PAD_WIDTH < ball->x - BALL_RADIUS) return false;
//    if (pad->x - PAD_WIDTH > ball->x + BALL_RADIUS) return false;
//
//    if (pad->y + PAD_HEIGHT < ball->y - BALL_RADIUS) return false;
//    if (pad->y - PAD_HEIGHT > ball->y + BALL_RADIUS) return false;


    if (fabsf(pad->x - ball->x) > PAD_WIDTH + BALL_RADIUS) return false;
    if (fabsf(pad->y - ball->y) > PAD_HEIGHT + BALL_RADIUS) return false;

    return true;
}

static float clamp(float x, float m, float M) {
    if (x < m) return m;
    if (x > M) return M;
    return x;
}

void logic(struct GameState *state, struct Pad *padOne, struct Pad *padTwo, struct Ball *ball) {
    if (padOne->controller_func) {
        padOne->deltaX = -padOne->x;
        padOne->deltaY = -padOne->y;

        padOne->controller_func(padOne, ball);

        padOne->x = clamp(padOne->x, -CAGE_WIDTH + PAD_WIDTH, CAGE_WIDTH - PAD_WIDTH);
        padOne->y = clamp(padOne->y, -CAGE_HEIGHT + PAD_HEIGHT, CAGE_HEIGHT - PAD_HEIGHT);

        padOne->deltaX += padOne->x;
        padOne->deltaY += padOne->y;
    }
    if (padTwo->controller_func) {
        padTwo->deltaX = -padTwo->x;
        padTwo->deltaY = -padTwo->y;

        padTwo->controller_func(padTwo, ball);

        padTwo->x = clamp(padTwo->x, -CAGE_WIDTH + PAD_WIDTH, CAGE_WIDTH - PAD_WIDTH);
        padTwo->y = clamp(padTwo->y, -CAGE_HEIGHT + PAD_HEIGHT, CAGE_HEIGHT - PAD_HEIGHT);

        padTwo->deltaX += padTwo->x;
        padTwo->deltaY += padTwo->y;
    }

    ball->x += ball->dirX;
    ball->y += ball->dirY;
    ball->z += ball->dirZ;

    if (ball->z >= padOne->z - 1.2f * BALL_RADIUS && ball->z <= padOne->z - 0.8f * BALL_RADIUS) {
        if (ball->dirZ > 0 && inPadRange(padOne, ball)) {
            ball->dirZ *= -1;

            ball->dirX += padOne->deltaX * BALL_PAD_INERTIA_FACTOR;
            ball->dirY += padOne->deltaY * BALL_PAD_INERTIA_FACTOR;
        }
    } else if (ball->z <= padTwo->z + 1.2f * BALL_RADIUS && ball->z >= padTwo->z + 0.8f * BALL_RADIUS) {
        if (ball->dirZ < 0 && inPadRange(padTwo, ball)) {
            ball->dirZ *= -1;

            ball->dirX += padTwo->deltaX * BALL_PAD_INERTIA_FACTOR;
            ball->dirY += padTwo->deltaY * BALL_PAD_INERTIA_FACTOR;
        }
    }

    if (ball->z >= padOne->z) {
        state->controller_padone_lost(state, padOne, padTwo, ball);
    }

    if (ball->z <= padTwo->z) {
        state->controller_padtwo_lost(state, padOne, padTwo, ball);
    }

    if (ball->x >= CAGE_WIDTH - BALL_RADIUS && ball->dirX > 0) {
        ball->dirX *= -1;
    }

    if (ball->x <= -CAGE_WIDTH + BALL_RADIUS && ball->dirX < 0) {
        ball->dirX *= -1;
    }

    if (ball->y >= CAGE_HEIGHT - BALL_RADIUS && ball->dirY > 0) {
        ball->dirY *= -1;
    }

    if (ball->y <= -CAGE_HEIGHT + BALL_RADIUS && ball->dirY < 0) {
        ball->dirY *= -1;
    }
}
