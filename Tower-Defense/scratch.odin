package TowerDefense

import rl "vendor:raylib"


Tower :: struct {
    pos         : [2]f32, // raylib.Vector2
    lvl         : i32,
    fire_rate   : f32,
    hitbox      : Hitbox,
    projectile  : []Projectile, // Can hold multiple different types?
    alive       : bool,

}

Projectile :: struct {
    pos     : [2]f32, // raylib.Vector2 format
    vel     : [2]f32,
    active  : bool,
}

Enemy :: struct {
    pos     : [2]f32,
    vel     : [2]f32,
    speed   : f32,
    hitbox  : Hitbox,
    alive   : bool,
}

// HP Containing struct for all Entities 
Hitbox :: struct {
   rect : rl.Rectangle,
    hp  : i32,
}