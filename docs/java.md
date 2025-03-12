## Keybinds
```lua
-- These are defaults, so no need to copy them
require("Polydev").java.setup({
  keybinds = {
    ["<leader>jb"] = "JavaBuild" -- Building all Java Files in src directory in.
    ["<leader>jr"] = "JavaRun" -- Runs Main.java in the out folder in your project_root
    ["<leader>jnf"] = "NewJavaFile" -- Creates a new Java file in the current project src folder
    ["<leader>jnp"] = "NewJavaProject" -- Creates a new project in the project directory in the config, defaults to ~/Projects unless project_root is set
    ["<Esc>"] = "CloseTerminal" -- Closes terminal, esc by default. 
  }
})
```
