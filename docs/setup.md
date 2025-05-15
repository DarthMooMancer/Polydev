## **Project Manager**
> Note: The project manager closely follows the netrw keybinds and allows for project management all in one spot

| Binding          | Description   |
|------------------|-----------------|
| **Enter** | `Open file / Enter directory` |
| **Delete** | `Go to parent directory` |
| **/**    | `Filter (fuzzy search)` |
| **a**    | `Create new folder` |
| **%**    | `Create new file` |
| **x**    | `Create new auxilary file (ex. headers)` |
| **d**    | `Create new project` |
| **R**    | `Rename file/folder` |
| **D**    | `Delete file/folder` |
| **q**    | `Quit popup` |

> **WARNING**: Do not copy the defaults. Only change what you need for your workflow!

## **Project Root**
```lua
-- Automatically creates a project root if not already made.
-- Stores all projects in this root

-- Global --
globals = {
    project_root = "~/Projects"
}

-- Lua --
lua = {
    project_root = "~/{global_root}/Lua"
}

-- Html --
html = {
    project_root = "~/{global_root}/Html"
}

-- Rust --
rust = {
    project_root = "~/{global_root}/Rust"
}

-- Java --
java = {
    project_root = "~/{global_root}/Java"
}

-- Python --
python = {
    project_root = "~/{global_root}/Python"
}

-- C --
c = {
    project_root = "~/{global_root}/C"
}

-- C++ --
cpp = {
    project_root = "~/{global_root}/CPP"
}
```

## **Keybinds**

```lua
-- globals --
globals = {
    keybinds = {
        ["<leader>po"] = "PolydevManager",
    }
}

-- rust --
rust = {
    keybinds = {
        ["<leader>pr"] = "RustRun",
    }
}

-- java --
java = {
    keybinds = {
        ["<leader>pr"] = "JavaRun",
    }
}

-- python --
python = {
    keybinds = {
        ["<leader>pr"] = "PythonRun",
        ["<leader>pb"] = "PythonPip",
    }
}

-- lua --
lua = {
    keybinds = {
        ["<leader>pr"] = "LuaRun",
    }
}

-- c --
c = {
    keybinds = {
        ["<leader>pr"] = "CRun",
    }
}

-- cpp --
cpp = {
    keybinds = {
        ["<leader>pr"] = "CppRun",
    }
}

```

## **Terminal Configuration**
```lua
-- In Neovim 0.11+, numbers don't work so they will be reimplemented later
terminal = {
    preset = nil, -- also try : ("right", "corner")
    border = true
}
```
