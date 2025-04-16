### Lua Setup for Polydev 🐢

#### Key Notes ⚠️

* Polydev provides seamless integration with Lua projects, allowing you to easily run and manage Lua code.
* You must include a `<Project_name>.polydev` file in your project root directory for Polydev to recognize the project. Missing this file will lead to errors.
* The file structure should be organized to ensure smooth execution and functionality.

---

#### Keybinds 🎮

Below are the default keybinds for Lua projects using Polydev. You can adjust them to suit your personal preferences.

| Keybind             | Action                                          |
|---------------------|-------------------------------------------------|
| `<leader>pr`        | Run the Lua project                             |

##### Configuration Example:

```lua
-- These are the defaults for Lua, adjust as needed
require("Polydev").lua.setup({
    keybinds = {
        ["<leader>pr"] = "LuaRun",     -- Run the Lua project
    }
})
```

---

#### Lua Features ✨

* **Run Lua Projects**:  
  Easily run your Lua project from within your terminal using the `<leader>pr` keybind. This automatically runs your `init.lua` or the entry point of your Lua code.

* **Create New Lua Files**:  
  With the `<leader>nf` keybind, you can quickly create new Lua files in the `src` directory, maintaining an organized project structure.

---

#### File Structure 📂

Here’s the suggested directory structure for your Lua projects with Polydev:

| Directory/File Path        | Description                                         |
|----------------------------|-----------------------------------------------------|
| `<Project_name>.polydev`    | Project metadata file that Polydev uses for configuration |
| `lua/`                      | Directory containing the main Lua project files     |
| `lua/<Project_name>/init.lua` | The main entry point for your Lua project          |

##### Example File Structure:

```md
Projects/
└── Lua/
    └── Project_Name/
        ├── <Project_name>.polydev    -- Polydev configuration file
        └── lua/
            └── Project_name/
                └── init.lua         -- Main Lua file
```

---
