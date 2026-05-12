package clog

import "shared:argy"

cmd_identifier := argy.Descriptor {
    name     = "clog",
    location = .Beginning,
}

cmd_init := argy.Descriptor {
    name        = "init",
    match       = {"init", argy.Long_Short{long="init", short="i"}},
    location    = argy.Right_After{cmd_identifier.name},
    value_type  = .String,
}

// Going to have to support multiple targets/pieces after the first Value
cmd_add := argy.Descriptor {
    name        = "add",
    match       = {"add", argy.Long_Short{long="add", short="a"}},
    location    = argy.Right_After{cmd_identifier.name},
    value_type  = .String,
    value_required=true,
}