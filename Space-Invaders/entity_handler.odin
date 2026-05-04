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

update_formation :: proc (formation: ^InvaderFormation, dt: f32) {
    // Horizontal movement
    inv_movement_x := formation.speed * f32(formation.dir) * dt

    // Detect edges of screen
    if formation.max_bound.x + inv_movement_x > SCREEN_W - 40.0 ||
    formation.min_bound.x + inv_movement_x < 40.0 {
        // Reverse direction and step down
        formation.dir = -formation.dir
        for row in 0..<ENMY_ROWS {
            for col in 0..<ENMY_COLS {
                inv := formation.enemies[row][col]
                if !inv.alive { continue }
                inv.pos.y += formation.step
            }
        }
    } 
    else { // Normal horizontal movement (not touching edge)
        for row in 0..<ENMY_ROWS {
            for col in 0..<ENMY_COLS {
                inv := formation.enemies[row][col]
                if !inv.alive { continue }
                inv.pos.x += inv_movement_x 
            }
        }
    }

    update_formation_bounds(formation)
}

update_bullets :: proc(player_b: ^Bullet, enemy_b: ^[64]Bullet, dt: f32) {
    if player_b.active {
        // Handle the movement of the player's projectile
        player_b.pos.y += player_b.vel.y * dt
        if player_b.pos.y < 0.0 { player_b.active = false }
    }

    // Odin implicity knows &b is reffering to what's in this array
    for &b in enemy_b { 
        if !b.active { continue }
        b.pos.y += b.vel.y * dt
        if b.pos.y > SCREEN_H {
            b.active = false
        }
    }
}