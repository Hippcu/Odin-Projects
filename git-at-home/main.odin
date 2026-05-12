package clog 

import "core:fmt"
import "core:os"

import "shared:argy" 

import "vendor:zlib" 

main :: proc() 
{
    args := argy.parse({
        cmd_identifier, 
        cmd_init,
        cmd_add,

        // Anything after a subcommand 
        {
            name        = "target",
            match       = {argy.Anything{}},
            location    = argy.After{"clog"}
        },

    }, os.args); defer delete(args)


    // case/switch statement on matches
    
    
    fmt.println(args)
}
