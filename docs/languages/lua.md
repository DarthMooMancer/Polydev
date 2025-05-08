### **Lua Features**

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
