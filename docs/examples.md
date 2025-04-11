### Lazy and Config
```lua
-- There is no need to copy this. This is an example and it consists of the defaults. This is a c example
return {
    'DarthMooMancer/Polydev',
    opts = {
        c = {
            build_attributes = "-DBUILD_SHARED_LIBS=OFF" 
            project_root = "~/Projects/C",
            keybinds = {
                ["<Esc>"] = "CloseTerminal",
                ["<leader>pb"] = "CBuild",
                ["<leader>pr"] = "CRun",
                ["<leader>nh"] = "NewCHeaderFile",
            },
            terminal = {
                right_padding = 0,
                bottom_padding = 0,
                left_padding = 0,
                top_padding = 0,
                border = true,
                number = true,
                relativenumber = true,
                scroll = true,
            },
        }
    }
}
```
