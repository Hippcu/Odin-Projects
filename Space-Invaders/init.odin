package spaceinvaders

import rl "vendor:raylib"

init_player :: proc() -> Player 
{
    return Player{
        pos   = rl.Vector2{SCREEN_W / 2.0, SCREEN_H - 40},
        speed = 200,
        alive = true,
    }
}

init_invaders :: proc() -> InvaderFormation 
{
    formation: InvaderFormation
    formation.dir = 1
    formation.speed = 100.0
    formation.step = 20.0

    start_x: f32 = 100.0
    start_y: f32 = 40.0
    spacing_x: f32 = 40.0
    spacing_y: f32 = 30.0

    for row in 0..<ENMY_ROWS 
    {
        for col in 0..<ENMY_COLS {
            formation.enemies[row][col] = Invader{
                pos = rl.Vector2{
                    start_x + f32(col) * spacing_x,
                    start_y + f32(row) * spacing_y,
                },
                alive = true,
            }
        }
    }

    update_formation_bounds(&formation)
    return formation
}

reset_game :: proc(
    player: ^Player,
    player_bullet: ^Bullet,
    formation: ^InvaderFormation,
    enemy_bullets: ^[ENEMY_BULLET_POOL_SIZE]Bullet,
) {
    player^ = init_player()
    player_bullet.active = false
    formation^ = init_invaders()
    for &b in enemy_bullets {
        b.active = false
    }
}
