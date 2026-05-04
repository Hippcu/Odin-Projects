package main

import "core:fmt"
import rl "vendor:raylib"

main :: proc() 
{
    // Settings/Pre-settings config
    rl.InitWindow(SCREEN_W, SCREEN_H, "Space-Invaders") // Settings from init.odin
    rl.SetTargetFPS(60)

    // Init the gameplay/interactable elements
    player := init_player()
    p_bullet: Bullet
    enemies := init_invaders()

    enemy_bullets: [64]Bullet // Simple pool of ammo

    // Begin Game Loop
    for !rl.WindowShouldClose() 
    {
        dt := rl.GetFrameTime()

        // Update Entities --> entity_handler
        update_player(&player, &p_bullet, dt)
        update_formation(&enemies, dt)
        update_enemy_shots(&enemies, &enemy_bullets, dt)
        update_bullets(&p_bullet, &enemy_bullets, dt)

        // Begin handling collisions after done testing
        handle_collision(&player, &p_bullet, &enemies, &enemy_bullets)

        // Raylib Functions
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        // Draw Entities --> entity_drawer
        draw_player(&player)
        draw_player_bullet(&p_bullet)
        draw_enemies(&enemies)
        draw_enemy_bullets(&enemy_bullets)


        if rl.IsKeyPressed(.ESCAPE) { break } // Close Main Loop
        rl.EndDrawing()
    }
    
    //free_all()
    fmt.println("Successfully closed")
    rl.CloseWindow()
}