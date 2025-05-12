### **Build**
```lua
-- Adds build attributes when compiling if you need extra arguments
build_attributes = ""
```

#### File Structure 📂
This is the recommended file structure for your C projects using Polydev:

| Directory/File Path        | Description                                          |
|----------------------------|------------------------------------------------------|
| `CMakeLists.txt`            | Configuration file for your project build            |
| `src/`                      | Folder containing source files for the project      |
| `main.c`                    | Main C file for the project                          |
| `*.c`                       | Additional C source files                           |
| `build/`                    | Folder where the build artifacts will be generated |
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
        │   └── <main-executable>
        └── include/
            └── *.h
```
---
