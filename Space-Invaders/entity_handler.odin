package spaceinvaders

import rl "vendor:raylib"

EDGE_MARGIN :: 10.0

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
    // This magic number 12 is half the size of the invader across, it's like 4am
    if formation.max_bound.x + 12 + inv_movement_x > SCREEN_W - EDGE_MARGIN ||
    formation.min_bound.x - 12 + inv_movement_x < EDGE_MARGIN {
        // Reverse direction and step down
        formation.dir = -formation.dir
        for row in 0..<ENMY_ROWS {
            for col in 0..<ENMY_COLS {
                inv := &formation.enemies[row][col]
                if !inv.alive { continue }
                inv.pos.y += formation.step
            }
        }
    } 
    else { // Normal horizontal movement (not touching edge)
        for row in 0..<ENMY_ROWS {
            for col in 0..<ENMY_COLS {
                inv := &formation.enemies[row][col]
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

update_enemy_shots :: proc (f: ^InvaderFormation, pool: ^[64]Bullet, dt: f32) {
    // EXTREMELY simple firing method... I'm tired
    column_cd : [ENMY_COLS]f32
    
    for col in 0..<ENMY_COLS {
        if column_cd[col] > 0 {
            column_cd[col] -= dt
        }
    }

    for col in 0..<ENMY_COLS {
        if column_cd[col] > 0 { continue }

        // find lowest alive invader in this column
        lowest: ^Invader = nil
        for row in 0..<ENMY_ROWS {
            inv := &f.enemies[row][col]
            if !inv.alive { continue }
            if lowest == nil || inv.pos.y > lowest.pos.y {
                lowest = inv
            }
        }
        if lowest == nil { continue }

        // small chance to fire
        if rl.GetRandomValue(0, 1000) < 5 {
            // spawn bullet
            for &b in pool {
                if !b.active {
                    b.active = true
                    b.pos = rl.Vector2{ lowest.pos.x, lowest.pos.y + 10 }
                    b.vel = rl.Vector2{ 0, 150 }
                    break
                }
            }

            // set cooldown (randomized)
            column_cd[col] = 0.5 + f32(rl.GetRandomValue(0, 200)) / 200.0
        }
    }
}

// Collision helper
rect_point_hit :: proc(r: rl.Rectangle, p: rl.Vector2) -> bool {
    return p.x >= r.x &&
    p.x <= r.x + r.width &&
    p.y >= r.y &&
    p.y <= r.y + r.height
}

// Collision Manager
handle_collision :: proc(p: ^Player, p_b: ^Bullet, f: ^InvaderFormation, e_b: ^[64]Bullet) {
    if p_b.active {
        for row in 0..<ENMY_ROWS {
            for col in 0..<ENMY_COLS {
                inv := &f.enemies[row][col]
                if !inv.alive { continue }

                inv_rect := rl.Rectangle{
                    inv.pos.x - 12.0,
                    inv.pos.y - 8.0,
                    24.0,
                    16.0,
                }

                if rect_point_hit(inv_rect, p_b.pos) {
                    inv.alive = false
                    p_b.active = false
                    // Slightly increase invader speed?
                    f.speed += 1.0
                    update_formation_bounds(f)
                    break
                }
            }
        }
    }

    // Handle Collision between enemy bullets and player
    if p.alive {
        player_rect := rl.Rectangle{
            p.pos.x - 15.0,
            p.pos.y - 10.0,
            30.0,
            15.0,
        }

        for &b in e_b {
            if !b.active { continue }
            if rect_point_hit(player_rect, b.pos) {
                b.active = false
                p.alive = false
            }
        }
    }
}