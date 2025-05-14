<h1 align="center">Polydev</h1>

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

## 💡 Why Polydev?

Modern development often involves juggling multiple languages. Setting up similar environments repeatedly or manually running commands wastes time. Polydev solves this by providing:

- 📦 **Project templates per language**
- 🎯 **Custom keybindings for common actions**
- 💻 **Floating terminal support**
- 🗂 **Easy file creation and directory structure generation**
- 🔌 **Plugin-first architecture to expand functionality**

## 🔧 Core Features

- 🌐 **Language Support**: Define custom settings per language including `project_root`, `keybinds`, and `build_attributes`.
- 🪟 **Floating Terminals**: Run builds and executions in a Neovim floating terminal.
- 🧱 **Scaffolding**: Automatically create the appropriate directory and file layout for new projects.
- 🎹 **Keybind Mapping**: Rebind keys to execute project-specific commands like `Run`, or `Test`.
- 🔌 **Pluggable**: Designed to easily integrate with other tools or extend with your own commands and language presets.

## 👥 Target Audience

Polydev is perfect for:

- 🧑‍💻 Developers building across multiple languages
- 🔌 Plugin authors and power users of Neovim
- ⚡ Anyone who wants automated project bootstrapping

## 🎯 Goals

- 📏 **Consistency**: Provide a common interface for all your dev projects.
- 🧩 **Extensibility**: Let users add their own languages and tools.
- ✨ **Simplicity**: Reduce boilerplate and context switching.

## 🧪 Example Use Case

Say you're a developer who works with Rust, Lua, and Python. Instead of remembering build commands, directory structures, or manually creating a `main.rs` or `init.lua`, Polydev:

1. 🏗 Sets up your directory based on language conventions.
2. 📄 Generates boilerplate files.
3. 🎛 Maps `<leader>pr` to `Run`, `<leader>po` to `Open Polydev Project Manager`, and so on.
4. 🖥 Opens a floating terminal to show your output.

## 🏷 Versioning

Polydev uses GitHub tags and branches to manage plugin versions. Each version corresponds to a stable release that users can track.

---
