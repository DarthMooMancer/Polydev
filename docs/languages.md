## Java

#### Structure Reference

| Directory/File Path        | Description                                          |
|----------------------------|------------------------------------------------------|
| `src/`                     | Contains the source code files, including `Main.java` |
| `build/`                   | Contains compiled `.class` files                     |
| `Main.java`                | The main entry point of your Java project             |
| `.gitingore`               | Ignores files for things like Telescope and pushing to github |

#### Project Layout

```md
Projects/
└── Java/
    └── Project_Name/
        ├── src/
        │   └── Main.java
        ├── build/
        │   └── *.class
        └── .gitingore
```

---

## C

#### Structure Reference

| Directory/File Path        | Description                                          |
|----------------------------|------------------------------------------------------|
| `CMakeLists.txt`            | Configuration file for your project build            |
| `src/`                      | Folder containing source files for the project      |
| `main.c`                    | Main C file for the project                          |
| `*.c`                       | Additional C source files                           |
| `build/`                    | Folder where the build artifacts will be generated |
| `include/`                  | Folder for header files                             |
| `*.h`                       | C header files                                       |
| `.gitingore`               | Ignores files for things like Telescope and pushing to github |

#### Project Layout

```md
Projects/
└── C/
    └── Project_Name/
        ├── CMakeLists.txt
        ├── src/
        │   ├── main.c
        │   └── *.c
        ├── .gitingore
        ├── build/
        │   └── <CMAKE_FILES>
        │   └── <main-executable>
        └── include/
            └── *.h
```

---

## C++

#### Structure Reference

| Directory/File Path        | Description                                          |
|----------------------------|------------------------------------------------------|
| `CMakeLists.txt`            | Configuration file for your project build            |
| `src/`                      | Folder containing source files for the project      |
| `main.cpp`                  | Main Cpp file for the project                          |
| `*.cpp`                     | Additional Cpp source files                           |
| `build/`                    | Folder where the build artifacts will be generated |
| `include/`                  | Folder for header files                             |
| `*.hpp`                     | Cpp header files                                       |
| `.gitingore`               | Ignores files for things like Telescope and pushing to github |

#### Project Layout

```md
Projects/
└── Cpp/
    └── Project_Name/
        ├── CMakeLists.txt
        ├── .gitingore
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

## Lua

#### Structure Reference

| Directory/File Path        | Description                                         |
|----------------------------|-----------------------------------------------------|
| `lua/<Project_name>`                      | Directory containing the main Lua project files     |
| `lua/<Project_name>/init.lua` | The main entry point for your Lua project          |
| `.gitingore`               | Ignores files for things like Telescope and pushing to github |

#### Project Layout

```md
Projects/
└── Lua/
    └── Project_Name/
        ├── .gitingore
        └── lua/
            └── Project_name/
                └── init.lua         -- Main Lua file
```

---

## Python

- **Automatic Virtual Environment Creation**: Each Python project automatically sets up and uses a new virtual environment. You don’t need to worry about environment management. Just install your dependencies with `pip` as needed.

- **Dependency Management with Pip**: Need to install Python modules? Simply type the name of the module in the terminal, and Polydev will take care of the installation using `pip`. You can even update `pip` if required, ensuring smooth installation.

#### Structure Reference

| Directory/File Path        | Description                                          |
|----------------------------|------------------------------------------------------|
| `requirements.txt`          | File for listing project dependencies                |
| `setup.py`                  | Python project setup file                            |
| `tests/`                    | Folder containing test files                         |
| `venv/`                     | Virtual environment folder                           |
| `main.py`                   | Main Python file for your project                    |
| `.gitingore`               | Ignores files for things like Telescope and pushing to github |

#### Project Layout

```md
Projects/
└── Python/
    └── Project_Name/
        ├── .gitingore
        ├── main.py
        ├── requirements.txt
        ├── setup.py
        ├── tests/
        └── venv/
```

---

## Html

Nothing here yet! Html is supported however! Will do later

## Rust

Nothing here yet! Rust is supported however! Will do later
