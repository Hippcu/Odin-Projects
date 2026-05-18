package spaceinvaders

import rl "vendor:raylib"

draw_player :: proc(p: ^Player) 
{
    if !p.alive { return }
    rl.DrawRectangle(
        cast(i32)(p.pos.x - PLAYER_HALF_W),
        cast(i32)(p.pos.y - PLAYER_DRAW_HALF_H),
        cast(i32)PLAYER_W,
        cast(i32)PLAYER_DRAW_H,
        rl.GREEN,
    )
}

draw_player_bullet :: proc(b: ^Bullet) 
{
    if !b.active { return }
    rl.DrawRectangle(
        cast(i32)(b.pos.x - 2.0),
        cast(i32)(b.pos.y - 6.0),
        4, 12,
        rl.WHITE,
    )
}

draw_enemies :: proc(formation: ^InvaderFormation) 
{
    for row in 0..<ENMY_ROWS {
        for col in 0..<ENMY_COLS {
            inv := &formation.enemies[row][col]
            if !inv.alive { continue }
            rl.DrawRectangle(
                cast(i32)(inv.pos.x - INVADER_HALF_W),
                cast(i32)(inv.pos.y - INVADER_HALF_H),
                cast(i32)INVADER_W,
                cast(i32)INVADER_H,
                rl.SKYBLUE,
            )
        }
    }
}

draw_enemy_bullets :: proc(pool: ^[ENEMY_BULLET_POOL_SIZE]Bullet) 
{
    for &b in pool {
        if !b.active { continue }
        rl.DrawRectangle(
            cast(i32)(b.pos.x - 2.0),
            cast(i32)(b.pos.y - 6.0),
            4, 12,
            rl.RED,
        )
    }
}
