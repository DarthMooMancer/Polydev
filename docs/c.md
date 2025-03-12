## Keybinds
```lua
require("Polydev").c.setup({
  keybinds = {
    ["<Esc>"] = "CloseTerminal" -- Closes terminal, esc by default. 
    ["<leader>cb"] = "CBuild", -- Building all C Files in src directory in.
    ["<leader>cr"] = "CRun", -- Runs <Project_name> in your build directory 
    ["<leader>cnf"] = "NewCFile", -- Creates a new c file in the current project src folder
    ["<leader>cnp"] = "NewCHeaderFile", -- Creates a new header file in the current project src folder
    ["<leader>cnh"] = "NewCProject", -- Creates a new project in the project directory in the config, defaults to ~/Projects/C unless project_root is set
  },
})
```
