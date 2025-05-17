## **Project Manager**
> Note: The project manager closely follows the netrw keybinds and allows for project management all in one spot

| Binding          | Description   |
|------------------|-----------------|
| **ENTER** | `Open file / Enter directory` |
| **DELETE** | `Go to parent directory` |
| **/**    | `Filter (fuzzy search)` |
| **a**    | `Create new folder` |
| **%**    | `Create new file` |
| **x**    | `Create new auxilary file (ex. headers)` |
| **d**    | `Create new project` |
| **R**    | `Rename file/folder` |
| **D**    | `Delete file/folder` |
| **ESC**    | `Quit popup` |

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
terminal = {
    -- floating or split
    mode = "split",
    win = {
        -- type: "vertical" or "horizonal" -- Only for split windows
        -- anchor: "bottom" or "right" or "center" or "corner"
            -- "bottom" and "right" are only split anchors
            -- "center" and "corner" are only floating anchors
        type = "vertical", anchor = "right"
    },
    border = {
        enabled = true,
        -- type: border decoration, follows `winborder`
            -- "bold": Bold line box.
            -- "double": Double-line box.
            -- "none": No border.
            -- "rounded": Like "single", but with rounded corners ("╭" etc.).
            -- "shadow": Drop shadow effect, by blending with the background.
            -- "single": Single-line box.
            -- "solid": Adds padding by a single whitespace cell.
        type = "rounded"
    }
}
```
