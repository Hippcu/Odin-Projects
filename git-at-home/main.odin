package cit

import cli "shared:odin-cli"
import "core:os"
import "core:fmt"

main :: proc()
{
    args := os.args
    // os.args[0] is the executable name ("cit"), so start at [1:]
    if len(args) < 2 {
        fmt.println("cit: no command, no targets")
        return
    }

    _command, remaining_arguments, cli_err :=
     cli.parse_arguments_as_type(args[1:], COMMAND)
    
    if cli_err != nil {
        // For now everything is a generic target
        targs := args[1:]
        fmt.printfln("cit invoked with targets: %v", targs)
        return
    }

    // Switch statement to direct commands
    switch c in _command {
        case INIT:
            run_init(c, remaining_arguments) 
        case ADD:
            run_add(c, remaining_arguments)
    }
}