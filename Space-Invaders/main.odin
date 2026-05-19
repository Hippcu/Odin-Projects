package spaceinvaders

import "core:fmt"
import rl "vendor:raylib"

main :: proc() 
{
    // Settings init
    rl.InitWindow(SCREEN_W, SCREEN_H, "Space-Invaders")
    rl.SetTargetFPS(60)

    // Init gameplay elements
    player := init_player()
    player_bullet: Bullet
    enemies := init_invaders()
    enemy_bullets: [ENEMY_BULLET_POOL_SIZE]Bullet
    game_over := false

    // Begin the game loop
    for !rl.WindowShouldClose() 
    {
        dt := rl.GetFrameTime()

        if !game_over {
            update_player(&player, &player_bullet, dt)
            update_formation(&enemies, dt)
            update_enemy_shots(&enemies, &enemy_bullets, dt)
            update_bullets(&player_bullet, &enemy_bullets, dt)
            handle_collision(&player, &player_bullet, &enemies, &enemy_bullets)

            if all_enemies_gone(&enemies) {
                game_over = true
            }
        }

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        draw_player(&player)
        draw_player_bullet(&player_bullet)
        draw_enemies(&enemies)
        draw_enemy_bullets(&enemy_bullets)

        if game_over {
            draw_game_over()
            if rl.IsKeyPressed(.SPACE) {
                reset_game(&player, &player_bullet, &enemies, &enemy_bullets)
                game_over = false
            }
        } else if !player.alive {
            draw_game_over()
            try_revive_player(&player)
        }

        if rl.IsKeyPressed(.ESCAPE) { break }
        rl.EndDrawing()
    }

    fmt.println("Successfully closed")
    rl.CloseWindow()
}

GAME_OVER_FONT_SIZE :: 34
GAME_OVER_TEXT :: "PRESS SPACE TO CONTINUE"

draw_game_over :: proc() 
{
    text_width := rl.MeasureText(GAME_OVER_TEXT, GAME_OVER_FONT_SIZE)
    rl.DrawText(
        GAME_OVER_TEXT,
        (SCREEN_W / 2) - (text_width / 2),
        (SCREEN_H / 2) - (GAME_OVER_FONT_SIZE / 2),
        GAME_OVER_FONT_SIZE,
        rl.WHITE,
    )
}

try_revive_player :: proc(p: ^Player) 
{
    if rl.IsKeyPressed(.SPACE) { p.alive = true }
}
