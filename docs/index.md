<p align="center"><em>A multi-language project managing plugin for file creation, building, and running code—all within neovim. Whether you're coding in Java, Python, Lua, Rust, or more, Polydev provides seamless integration to boost your productivity inside Neovim.</em></p>

<p align="center">
  <img src="https://img.shields.io/badge/Lua-1e90ff?style=for-the-badge&logo=lua&logoColor=white" />
  <img src="https://img.shields.io/badge/Neovim-0.10%2B-32c48d?style=for-the-badge&logo=neovim&logoColor=white" />
  <img src="https://img.shields.io/github/stars/DarthMooMancer/Polydev?style=for-the-badge&logo=github" />
  <img src="https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Docs-Available-blue?style=for-the-badge&logo=readthedocs&logoColor=white" />
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/c8e84056-5080-4ec3-ba15-30be61faaf68" alt="Polydev Preview" width="720"/>
</p>


## **Why Polydev**?

Working across multiple languages often means repetitive setup and constant context switching. Polydev eliminates this friction by offering:

* Project templates per language
* Custom keybindings for essential actions
* Floating terminal integration
* Automated file and folder generation
* A plugin-first design for easy extensibility


## **Core Features**

* **Language Profiles**
  Define settings per language including `project_root`, keymaps, and build commands.

* **Floating Terminals**
  Run build, and run commands in a clean, isolated terminal window inside Neovim.

* **Scaffolding**
  Quickly generate boilerplate and structured directories for new projects.

* **Custom Keybinds**
  Map actions like `Run`, `PipInstall`, `Open Manager`, `etc` to your preferred keys.

* **Pluggable Design**
  Easily extend functionality with custom language presets and commands.


## **Who It's For**

* Developers who work in multiple languages
* Neovim plugin authors or power users
* Anyone who wants a faster, more unified project workflow


## **Design Goals**

* **Consistency**
  Offer a predictable workflow across languages and tools.

* **Extensibility**
  Support custom configurations, commands, and language integrations.

* **Simplicity**
  Reduce boilerplate, context switching, and friction.


## **Real-World Example**

If you switch often between Rust, Lua, and Python:

1. Polydev sets up your project layout automatically.
2. Creates boilerplate like `main.rs`, `init.lua`, or `main.py`.
3. Maps commands to keys (e.g. `<leader>pr` to run, `<leader>po` to open the manager).
4. Opens a floating terminal with build or run output — no extra configuration required.
