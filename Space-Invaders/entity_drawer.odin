package main

import rl "vendor:raylib"

draw_player :: proc (p: ^Player) {
    if !p.alive { return }
    rl.DrawRectangle(
        cast(i32)(p.pos.x - 15.0), //DrawRect requires i32, Vec2 is 2[f32]
        cast(i32)(p.pos.y - 10.0),
        30, 20,
        rl.GREEN,
    )
}

draw_player_bullet :: proc (b: ^Bullet) {
    if !b.active { return }
    rl.DrawRectangle(
        cast(i32)(b.pos.x - 2.0),
        cast(i32)(b.pos.y - 6.0),
        4, 12,
        rl.WHITE,
    )
}

draw_enemy :: proc (f: ^InvaderFormation) {
    for row in 0..<ENMY_ROWS {
        for col in 0..<ENMY_COLS {
            inv := &f.enemies[row][col]
            if !inv.alive { continue }
            rl.DrawRectangle(
                cast(i32)(inv.pos.x - 12.0),
                cast(i32)(inv.pos.y -8.0),
                24, 16,
                rl.SKYBLUE
            )
        }
    }
}