### C Setup for Polydev 🛠️

#### Key Notes ⚠️
> **Important**: The first time you build a project, it might throw an error. This is expected behavior. Simply rerun the build, and if errors persist, it may be an issue with your project setup rather than the plugin.

---

#### Keybinds 🎮
You can customize keybinds for your C projects with Polydev.

| Keybind             | Action                                           |
|---------------------|--------------------------------------------------|
| `<leader>pb`        | Build all C files in the `src` directory         |
| `<leader>pr`        | Run `<Project_name>` in your build directory     |
| `<leader>nh`        | Create a new header file in the current project’s `src` folder |

#### Configuration Example:

```lua
require("Polydev").c.setup({
  keybinds = {
    ["<leader>pb"] = "CBuild",    -- Build all C files in the src directory
    ["<leader>pr"] = "CRun",      -- Run <Project_name> in your build directory
    ["<leader>nh"] = "NewCHeaderFile"  -- Create a new header file in the current project’s src folder
  }
})
```

---

#### File Structure 📂
This is the recommended file structure for your C projects using Polydev:

| Directory/File Path        | Description                                          |
|----------------------------|------------------------------------------------------|
| `CMakeLists.txt`            | Configuration file for your project build            |
| `src/`                      | Folder containing source files for the project      |
| `main.c`                    | Main C file for the project                          |
| `*.c`                       | Additional C source files                           |
| `build/`                    | Folder where the build artifacts will be generated |
| `<project_name>.polydev`    | Polydev metadata file (generated during build)      |
| `include/`                  | Folder for header files                             |
| `*.h`                       | C header files                                       |

#### Example Structure:

```md
Projects/
└── C/
    └── Project_Name/
        ├── CMakeLists.txt
        ├── src/
        │   ├── main.c
        │   └── *.c
        ├── build/
        │   └── <project_name>.polydev
        └── include/
            └── *.h
```

---
