## Key Notes
* Currently with the way I have it work, the first time you build a project, it will error out no matter what. Just rerun the build and then if there are errors it is most likely a you issue more than a me issue.

## Keybinds
```lua
require("Polydev").c.setup({
  keybinds = {
    ["<Esc>"] = "CloseTerminal" -- Closes terminal, esc by default. 
    ["<leader>pb"] = "CBuild", -- Building all C Files in src directory in.
    ["<leader>pr"] = "CRun", -- Runs <Project_name> in your build directory 
    ["<leader>nf"] = "NewCFile", -- Creates a new c file in the current project src folder
    ["<leader>nh"] = "NewCHeaderFile", -- Creates a new header file in the current project src folder
})
```

## File Structure
```md
Projects/
└── C/
    └── Project_Name/
        ├── CMakeLists.txt
        ├── src/
        │   ├── main.c
        │   └── *.c
        ├── build/
        │   └── <project_name>.polydev
        └── include/
            └── *.h
```
