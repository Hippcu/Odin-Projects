package clog

import "core:fmt"

// Subcommand Logic 

run_init :: proc(args: []string) {
    val : string = ""
    if len(args) > 0 {
        val = args[0]
    }

    // Takes in an optional string value
    fmt.printfln("running clog init with: %v value", val)
}

run_add :: proc(args: []string) {

}