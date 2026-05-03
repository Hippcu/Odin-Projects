package main

import rl "vendor:raylib"

SCREEN_W, SCREEN_H :: 800, 600

init_player :: proc () -> Player {
    return Player {
        pos     = rl.Vector2{ SCREEN_W / 2.0, SCREEN_H - 40 }, // (400, 560) starting position
        speed   = 200,
        alive   = true 
    }
}

init_invaders :: proc () -> InvaderFormation {
   formation : InvaderFormation
   formation.dir     = 1
   formation.speed   = 40.0
   formation.step    = 20.0

   // Now the annoying mathy part
   // Depends on the spacing/how large the invaders are... spacing spacing
   // Maybe a little Odin array action?
   start_x      := 100.0
   start_y      := 80.0
   spacing_x    := 40
   spacing_y    := 30.0



}