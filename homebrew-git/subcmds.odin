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
// cit add --dry-run
ADD :: struct {
    message: string `cli:"m,message/required"`, // -m <msg> required
    dry_run: bool `cli:"d, dry-run"`            // -d or --dry-run
}


/*
    Procs for various COMMANDS
*/

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
        fmt.println("cit add: requires at least one arg")
        os.exit(1)
    }

    fmt.println("Running `cit add` with:", args)
}