package spaceinvaders

import rl "vendor:raylib"

update_player :: proc(p: ^Player, b: ^Bullet, dt: f32) 
{
    if !p.alive { return }

    if rl.IsKeyDown(.LEFT) { p.pos.x -= p.speed * dt }
    if rl.IsKeyDown(.RIGHT) { p.pos.x += p.speed * dt }

    if p.pos.x < PLAYER_BOUND_MARGIN { p.pos.x = PLAYER_BOUND_MARGIN }
    if p.pos.x > SCREEN_W - PLAYER_BOUND_MARGIN { p.pos.x = SCREEN_W - PLAYER_BOUND_MARGIN }

    if rl.IsKeyPressed(.SPACE) && !b.active {
        b.pos = rl.Vector2{p.pos.x, p.pos.y - 10.0}
        b.vel = rl.Vector2{0.0, -500.0}
        b.active = true
    }
}

all_enemies_gone :: proc(formation: ^InvaderFormation) -> bool 
{
    for row in 0..<ENMY_ROWS {
        for col in 0..<ENMY_COLS {
            inv := &formation.enemies[row][col]
            if !inv.alive { continue }
            if inv.pos.y <= SCREEN_H { return false }
        }
    }
    return true
}

update_formation_bounds :: proc(formation: ^InvaderFormation) 
{
    min_x := f32(SCREEN_W)
    max_x := f32(0.0)
    min_y := f32(SCREEN_H)
    max_y := f32(0.0)

    for row in 0..<ENMY_ROWS {
        for col in 0..<ENMY_COLS {
            inv := &formation.enemies[row][col]
            if !inv.alive { continue }
            if inv.pos.x < min_x do min_x = inv.pos.x
            if inv.pos.x > max_x do max_x = inv.pos.x
            if inv.pos.y < min_y do min_y = inv.pos.y
            if inv.pos.y > max_y do max_y = inv.pos.y
        }
    }

    formation.min_bound = rl.Vector2{min_x, min_y}
    formation.max_bound = rl.Vector2{max_x, max_y}
}

update_formation :: proc(formation: ^InvaderFormation, dt: f32) 
{
    dx := formation.speed * f32(formation.dir) * dt

    at_edge := formation.max_bound.x + INVADER_HALF_W + dx > SCREEN_W - EDGE_MARGIN ||
        formation.min_bound.x - INVADER_HALF_W + dx < EDGE_MARGIN

    if at_edge {
        formation.dir = -formation.dir
    }

    for row in 0..<ENMY_ROWS {
        for col in 0..<ENMY_COLS {
            inv := &formation.enemies[row][col]
            if !inv.alive { continue }
            if at_edge {
                inv.pos.y += formation.step
            } else {
                inv.pos.x += dx
            }
        }
    }

    update_formation_bounds(formation)
}

update_bullets :: proc(player_b: ^Bullet, enemy_b: ^[ENEMY_BULLET_POOL_SIZE]Bullet, dt: f32) 
{
    if player_b.active {
        player_b.pos.y += player_b.vel.y * dt
        if player_b.pos.y < 0.0 { 
            player_b.active = false 
        }
    }

    for &b in enemy_b {
        if !b.active { continue }
        b.pos.y += b.vel.y * dt
        if b.pos.y > SCREEN_H do b.active = false
    }
}

update_enemy_shots :: proc(formation: ^InvaderFormation, pool: ^[ENEMY_BULLET_POOL_SIZE]Bullet, dt: f32) 
{
    for col in 0..<ENMY_COLS {
        if formation.column_cd[col] > 0 {
            formation.column_cd[col] -= dt
        }
    }

    for col in 0..<ENMY_COLS 
    {
        if formation.column_cd[col] > 0 { continue }

        lowest: ^Invader = nil
        for row in 0..<ENMY_ROWS 
        {
            inv := &formation.enemies[row][col]
            if !inv.alive { continue }
            if lowest == nil || inv.pos.y > lowest.pos.y {
                lowest = inv
            }
        }
        if lowest == nil { continue }

        if rl.GetRandomValue(0, 1000) < 5 
        {
            for &b in pool 
            {
                if !b.active 
                {
                    b.active = true
                    b.pos = rl.Vector2{lowest.pos.x, lowest.pos.y + 10}
                    b.vel = rl.Vector2{0, 150}
                    break
                }
            }

            formation.column_cd[col] = 0.5 + f32(rl.GetRandomValue(0, 200)) / 200.0
        }
    }
}

rect_point_hit :: proc(r: rl.Rectangle, p: rl.Vector2) -> bool 
{
    return p.x >= r.x &&
        p.x <= r.x + r.width &&
        p.y >= r.y &&
        p.y <= r.y + r.height
}

handle_collision :: proc(
    p: ^Player,
    p_b: ^Bullet,
    formation: ^InvaderFormation,
    enemy_b: ^[ENEMY_BULLET_POOL_SIZE]Bullet,
) {
    if p_b.active {
    bullet_hit:
        for row in 0..<ENMY_ROWS {
            for col in 0..<ENMY_COLS {
                inv := &formation.enemies[row][col]
                if !inv.alive { continue }

                inv_rect := rl.Rectangle{
                    inv.pos.x - INVADER_HALF_W,
                    inv.pos.y - INVADER_HALF_H,
                    INVADER_W,
                    INVADER_H,
                }

                if rect_point_hit(inv_rect, p_b.pos) {
                    inv.alive = false
                    p_b.active = false
                    formation.speed += 1.0
                    update_formation_bounds(formation)
                    break bullet_hit
                }
            }
        }
    }

    if p.alive {
        player_rect := rl.Rectangle{
            p.pos.x - PLAYER_HALF_W,
            p.pos.y - PLAYER_DRAW_HALF_H,
            PLAYER_W,
            PLAYER_COLLISION_H,
        }

        for &b in enemy_b {
            if !b.active { continue }
            if rect_point_hit(player_rect, b.pos) {
                b.active = false
                p.alive = false
            }
        }
    }
}
