## Keybinds
```lua
-- These are defaults, so no need to copy them
require("Polydev").java.setup({
  keybinds = {
    ["<Esc>"] = "CloseTerminal" -- Closes terminal, esc by default.
    ["<leader>pb"] = "JavaBuild" -- Building all Java Files in src directory in.
    ["<leader>pr"] = "JavaRun" -- Runs Main.java in the out folder in your project_root
    ["<leader>nf"] = "NewJavaFile" -- Creates a new Java file in the current project src folder
  }
})
```
## File Structure

```md
Projects/
└── Java/
    └── Project_Name/
        ├── src/
        │   └── Main.java
        └── build/
            └── *.class
```
