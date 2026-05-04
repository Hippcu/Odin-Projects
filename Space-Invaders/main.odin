package main

import "core:fmt"
import rl "vendor:raylib"

main :: proc() 
{
    rl.InitWindow(SCREEN_W, SCREEN_H, "Space-Invaders") // Settings from init.odin
    rl.SetTargetFPS(60)

    player := init_player()

    enemies := init_invaders()


    for !rl.WindowShouldClose() 
    {
        dt := rl.GetFrameTime()

        update_formation(&enemies, dt)
        rl.BeginDrawing()

        rl.ClearBackground(rl.BLACK)


        if rl.IsKeyPressed(.ESCAPE) { break } // Close Main Loop
        rl.EndDrawing()
    }
    
    //free_all()
    fmt.println("Successfully closed")
    rl.CloseWindow()
}