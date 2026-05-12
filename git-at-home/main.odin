package clog

// Now using odin-cli instead of argy!
import cli "shared:odin-cli"
import "core:os"
import "core:fmt"

main :: proc()
{
    args := os.args
    // os.args[0] is the executable name ("clog"), so start at [1:]
    if len(args) < 2 {
        // No extra subcommands. "clog" alone
        fmt.println("clog: no command, no targets")
        return
    }

    _command, remaining_arguments, cli_error :=
     cli.parse_arguments_as_type(args[1:], COMMAND)
    
    if cli_error != nil {
        // Start workin if we typed clog
        // For now everything is a generic target
        targs := args[1:]
        fmt.printfln("clog invoked with targets: %v", targs)
        return
    }

    // Switch statement to direct commands
    switch c in _command {
        case INIT:
            run_init(remaining_arguments) 
        case ADD:
            run_add(remaining_arguments)
    }
}