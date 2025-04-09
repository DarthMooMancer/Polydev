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
* Each project with python creates a new virtual environment and automatically uses it so you dont have to worry, just install modules as you like.

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
