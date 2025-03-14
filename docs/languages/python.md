## Keybinds
```lua
require("Polydev").python.setup({
  keybinds = {
    ["<Esc>"] = "CloseTerminal",
    ["<leader>pr"] = "PythonRun",
    ["<leader>nf"] = "NewPythonFile",
    ["<leader>pb"] = "PythonPip"
  }
})
```

## File Structure
```md
Projects/
└── Python/
    └── Project_Name/
        ├── main.py
        ├── requirements.txt
        ├── setup.py
        ├── tests/
        └── venv/

```
