package main

import "core:fmt"
import rl "vendor:raylib"

main :: proc() 
{
    rl.InitWindow(SCREEN_W, SCREEN_H, "Space-Invaders") // Settings from init.odin

    for !rl.WindowShouldClose() 
    {
        rl.BeginDrawing()

        rl.ClearBackground(rl.BLACK)


        if rl.IsKeyPressed(.ESCAPE) { break } // Close Main Loop
        rl.EndDrawing()
    }
    
    //free_all()
    fmt.println("Successfully closed")
    rl.CloseWindow()
}