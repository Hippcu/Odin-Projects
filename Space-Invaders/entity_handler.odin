package main

import rl "vendor:raylib"

// Readjust the screen boundaries for the invaders
// Once again, SOA/Swizzle over nested loops but I'm not good at it
update_formation_bounds :: proc(formation: ^InvaderFormation) {
    min_x := f32(SCREEN_W)
    max_x := f32(0.0)
    min_y := f32(SCREEN_H)
    max_y := f32(0.0)

    for row in 0..<ENMY_ROWS {
        for col in 0..<ENMY_COLS {
            // Each individual 'invader'
            inv := &formation.enemies[row][col]
            if !inv.alive do continue
            if inv.pos.x < min_x do min_x = inv.pos.x
            if inv.pos.x > max_x do max_x = inv.pos.x
            if inv.pos.y < min_y do min_y = inv.pos.y
            if inv.pos.y > max_y do max_y = inv.pos.y
        }
    }

    formation.min_bound = rl.Vector2{ min_x, min_y }
    formation.max_bound = rl.Vector2{ max_x, max_y }
}
