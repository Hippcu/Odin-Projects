package spaceinvaders

import rl "vendor:raylib"

SCREEN_W, SCREEN_H :: 800, 600
EDGE_MARGIN :: 10.0
ENEMY_BULLET_POOL_SIZE :: 64

INVADER_W, INVADER_H :: 24.0, 16.0
INVADER_HALF_W :: INVADER_W * 0.5
INVADER_HALF_H :: INVADER_H * 0.5

PLAYER_W :: 30.0
PLAYER_DRAW_H :: 20.0
PLAYER_COLLISION_H :: 15.0
PLAYER_HALF_W :: PLAYER_W * 0.5
PLAYER_DRAW_HALF_H :: PLAYER_DRAW_H * 0.5
PLAYER_BOUND_MARGIN :: 20.0

Player :: struct {
    pos   : rl.Vector2,
    speed : f32,
    alive : bool,
}

Bullet :: struct {
    pos    : rl.Vector2,
    vel    : rl.Vector2,
    active : bool,
}

Invader :: struct {
    pos   : rl.Vector2,
    alive : bool,
}

ENMY_ROWS :: 5
ENMY_COLS :: 11

InvaderFormation :: struct {
    enemies   : [ENMY_ROWS][ENMY_COLS]Invader,
    dir       : i32,
    speed     : f32,
    step      : f32,
    min_bound : rl.Vector2,
    max_bound : rl.Vector2,
    column_cd : [ENMY_COLS]f32,
}
