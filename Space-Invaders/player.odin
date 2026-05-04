package main

import rl "vendor:raylib"

update_player :: proc(p: ^Player, b: ^Bullet, dt: f32) {
    if !p.alive { return }

    if rl.IsKeyDown(.LEFT) { p.pos.x -= p.speed * dt }
    if rl.IsKeyDown(.RIGHT) { p.pos.x += p.speed * dt }

    if p.pos.x < 20.0 { p.pos.x = 20.0 }
    if p.pos.x > SCREEN_W - 20.0 { p.pos.x = SCREEN_W - 20.0 }

    if rl.IsKeyPressed(.SPACE) && !b.active {
        b.pos       = rl.Vector2 { p.pos.x, p.pos.y - 10.0 }
        b.vel       = rl.Vector2 { 0.0, -400.0 }
        b.active    = true
    }
}