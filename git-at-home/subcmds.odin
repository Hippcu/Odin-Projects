package cit

import "core:fmt"
import "core:os"


COMMAND :: union {
    INIT,
    ADD,
}

// cit init -v
// cit init --config {file}
INIT :: struct {
    verbose: bool   `cli:"v,verbose"`, // -v or --verbose
    config:  string `cli:"c,config"`   // -c or --config <file>
}

// cit add -m "Insert Text"
ADD :: struct {
    message: string `cli:"m,message/required"`, // -m <msg> required
}

run_init :: proc(cmd: INIT, args: []string) {
    value: string = ""
    if len(args) > 0 {
        value = args[0]
    }

    // Allows the string afterwards to be optional.
    fmt.println("Running `cit init` with value:", value)
}

run_add :: proc(cmd: ADD, args: []string) {
    if len(args) == 0 {
        fmt.println("cit add: requires at least one piece")
        os.exit(1)
    }

    fmt.println("Running `cit add` with pieces:", args)
}