### Java Setup for Polydev ☕️

#### Keybinds 🎮
You can customize the keybinds for your Java projects in Polydev.

| Keybind             | Action                                              |
|---------------------|-----------------------------------------------------|
| `<leader>pr`        | Run `Main.java` from the `out` folder in your project |
| `<leader>nf`        | Create a new Java file in the `src` folder          |

#### Configuration Example:

```lua
-- These are defaults, so no need to copy them
require("Polydev").java.setup({
  keybinds = {
    ["<leader>pr"] = "JavaRun",    -- Run Main.java in the out folder
    ["<leader>nf"] = "NewJavaFile" -- Create a new Java file in the src folder
  }
})
```

---

#### Java Features ✨

* **Java Build and Run**:  
  Polydev allows you to build all Java files in the `src` directory with the press of a keybind. Once built, you can run the project from the `out` folder, with the `Main.java` file executed automatically.

* **Project File Management**:  
  The plugin manages your Java project files efficiently, helping you quickly add new Java files to the `src` directory. It also ensures that your build and run processes are streamlined.

---

#### File Structure 📂
Here’s the recommended structure for your Java projects using Polydev:

| Directory/File Path        | Description                                          |
|----------------------------|------------------------------------------------------|
| `src/`                     | Contains the source code files, including `Main.java` |
| `build/`                   | Contains compiled `.class` files                     |
| `Main.java`                | The main entry point of your Java project             |

#### Example Structure:

```md
Projects/
└── Java/
    └── Project_Name/
        ├── src/
        │   └── Main.java
        └── build/
            └── *.class
```

---
