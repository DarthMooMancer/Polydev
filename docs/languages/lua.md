## Keybinds
```lua
-- These are the defaults for lua
require("Polydev").lua.setup({
    keybinds = {
        ["<Esc>"] = "CloseTerminal",
        ["<leader>pr"] = "LuaRun",
        ["<leader>nf"] = "NewLuaFile",
    }
})
```

## File Structure
```md
Projects/
└── Lua/
    └── Project_Name/
        ├── <Project_name>.polydev
        └── lua/
            └── Project_name/
                └── init.lua
```
