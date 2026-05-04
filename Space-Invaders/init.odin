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
   formation.speed   = 100.0
   formation.step    = 20.0

   // Maybe a little Odin array action?
   start_x      := 100.0
   start_y      := 40.0
   spacing_x    := 40.0
   spacing_y    := 30.0

   // Can be replaced with SOA/swizzling, but brain too small
   for row in 0..<ENMY_ROWS {
    for col in 0..<ENMY_COLS {
        // Creation of the individual enemies
        formation.enemies[row][col] = Invader {
            pos = rl.Vector2{
                f32(start_x + f64(col) * spacing_x), // Man that's ugly 
                f32(start_y + f64(row) * spacing_y) // rl.Vector2 requires 2[f32]
            },
            alive = true,
        }
    }
   }

   update_formation_bounds(&formation) // Comes from entity_handler.odin
   return formation
}