#### File Structure 📂
This is the recommended file structure for your C projects using Polydev:

| Directory/File Path        | Description                                          |
|----------------------------|------------------------------------------------------|
| `CMakeLists.txt`            | Configuration file for your project build            |
| `src/`                      | Folder containing source files for the project      |
| `main.cpp`                  | Main Cpp file for the project                          |
| `*.cpp`                     | Additional Cpp source files                           |
| `build/`                    | Folder where the build artifacts will be generated |
| `include/`                  | Folder for header files                             |
| `*.hpp`                     | Cpp header files                                       |

#### Example Structure:

```md
Projects/
└── Cpp/
    └── Project_Name/
        ├── CMakeLists.txt
        ├── src/
        │   ├── main.cpp
        │   └── *.cpp
        ├── build/
        │   └── <CMAKE_FILES>
        │   └── <main-executable>
        └── include/
            └── *.hpp
```

---
