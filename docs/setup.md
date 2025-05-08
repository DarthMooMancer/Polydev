# **Setup**

> 💡 **Heads up!** Many language presets in Polydev require a file named `<project_name>.polydev` in your project root. If it's missing, Polydev will let you know (loudly 😅).

> **Note**: Languages that require to build just need to be run, building is builtin to the run command

## **Project Manager**
> Note: The project manager closely follows the netrw keybinds and allows for project management all in one spot

| Binding          | Description   |
|------------------|-----------------|
| **Enter** | `Open file / Enter directory` |
| **Delete** | `Go to parent directory` |
| **/**    | `Filter (fuzzy search)` |
| **a**    | `Create new folder` |
| **%**    | `Create new file` |
| **d**    | `Create new project` |
| **R**    | `Rename file/folder` |
| **D**    | `Delete file/folder` |
| **q**    | `Quit popup` |

> **WARNING**: Do not copy the defaults. Only change what you need for your workflow!

## **Project Root**
```lua
-- Automatically creates a project root if not already made.
-- Stores all projects in this root, not src files and such.
-- For now, the top project root is assumed at ~/Projects until I refactor my code.

-- Lua --
project_root = "~/Projects/Lua"

-- Html --
project_root = "~/Projects/Html"

-- Rust --
project_root = "~/Projects/Rust"

-- Java --
project_root = "~/Projects/Java"

-- Python --
project_root = "~/Projects/Python"

-- C --
project_root = "~/Projects/C"

-- C++ --
project_root = "~/Projects/Cpp"
```

## **Keybinds**

```lua
-- globals --
keybinds = {
    -- Opens the Project Manager UI
    ["<leader>po"] = "PolydevManager",
}

-- rust --
keybinds = {
    ["<leader>pr"] = "RustRun",
}

-- java --
keybinds = {
    ["<leader>pr"] = "JavaRun",
}

-- python --
keybinds = {
    ["<leader>pr"] = "PythonRun",
    ["<leader>pb"] = "PythonPip",
}

-- lua --
keybinds = {
    ["<leader>pr"] = "LuaRun",
}

-- c --
keybinds = {
    ["<leader>pr"] = "CRun",
    ["<leader>nh"] = "NewCHeaderFile",
}

-- cpp --
keybinds = {
    ["<leader>pr"] = "CppRun",
    ["<leader>nh"] = "NewCppHeaderFile",
}

```

## **Terminal Configuration**
```lua
terminal = {
    presets = "centered", -- "centered", "center_panel", "right_panel", "cornered"
    border = true,
    number = true,
    relativenumber = true -- requires number to be true
}
```

## 🚀 Final Thoughts and Customizations
This guide provided you with the basic configuration steps for setting up Polydev with your preferred package manager and customizing key aspects like project names, keybinds, and terminal settings.

You can further explore other Polydev features and modify the configuration to suit your development workflow with language specific configs.
