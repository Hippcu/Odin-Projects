package main

import rl "vendor:raylib"

Player :: struct 
{
    pos    : rl.Vector2,
    speed  : f32,
    alive  : bool,      // Keeps one-hit deaths and shielding simple
}

Bullet :: struct 
{
    pos     : rl.Vector2,
    vel     : rl.Vector2,
    active  : bool,
}

Invader :: struct 
{
    pos     : rl.Vector2,
    alive   : bool,     // Same as player, keeps damage simple
}

ENMY_ROWS :: 5
ENMY_COLS :: 11  // Maybe don't make them constants for a more fun/evolving game
InvaderFormation :: struct 
{
    enemies     : [ENMY_ROWS][ENMY_COLS]Invader,
    dir         : i32, // -1 Left +1 Right
    speed       : f32,
    step        : f32,
    min_bound   : rl.Vector2,
    max_bound   : rl.Vector2,
}

Shield :: struct 
{
    rect    : rl.Rectangle,
    hp      : i32,
}