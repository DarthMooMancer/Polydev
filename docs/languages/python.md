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

## Python Features
* A feature that is added to the python language for this plugin is to be able to install dependencies with pip within the terminal. You can even update pip. Just type your dependency you want and boom it is installed or not depending on if python likes you.

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
