# 📦 Installation

Polydev can be installed using any plugin manager of your choice—or even manually. Below are some examples for popular managers to get you started.

> ⚠️ **Disclaimer**: The `opts` and configuration values shown below are simply examples. You can customize them based on your preferences or even omit them entirely if not needed.
> 💡 **Heads up!** Many language presets in Polydev require a file named `<project_name>.polydev` in your project root. If it's missing, Polydev will let you know (loudly 😅).

---

## 🛌 Lazy.nvim

This is the **recommended** way if you're using [Lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "DarthMooMancer/Polydev",
  opts = {
    lua = {
      project_root = "~/Projects/Lua",
      keybinds = {
        ["<leader>pr"] = "LuaRun",
      },
    },
    terminal = {
      border = true,
      number = true,
    },
  },
}
```

> ✅ Keep the `opts` key! It’s the modern way of setting up plugins in Lazy.

---

## 🧸 Mini.deps

For users of [mini.nvim](https://github.com/echasnovski/mini.nvim)'s dependency manager:

```lua
MiniDeps.add({ source = "DarthMooMancer/Polydev" })

require("Polydev").setup({
  rust = {
    project_root = "~/Projects/Rust",
    keybinds = {
      ["<leader>pb"] = "RustBuild",
      ["<leader>pr"] = "RustRun",
    },
  },
  terminal = {
    border = true,
    number = true,
  },
})
```

---

## 📁 Packer.nvim

For fans of [Packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use({
  "DarthMooMancer/Polydev",
  config = function()
    require("Polydev").setup({
      python = {
        project_root = "~/Projects/Python",
        keybinds = {
          ["<leader>pb"] = "PythonPip",
          ["<leader>pr"] = "PythonRun",
        },
      },
      terminal = {
        relativenumber = true,
      },
    })
  end,
})
```

---

## 🔐 Vim-Plug (Classic)

Even if you're still using [vim-plug](https://github.com/junegunn/vim-plug), you’re covered:

```vim
Plug 'DarthMooMancer/Polydev'

lua << EOF
  require("Polydev").setup({
    c = {
      project_root = "~/Projects/C",
      keybinds = {
        ["<leader>pb"] = "CBuild",
        ["<leader>pr"] = "CRun",
      },
    },
    terminal = {
      number = true,
    },
  })
EOF
```

---

## 🛠 Manual Install

Clone the repo into your `~/.config/nvim/lua` or any runtime path:

```bash
git clone https://github.com/DarthMooMancer/Polydev ~/.config/nvim/lua/Polydev
```

Then in your config:

```lua
require("Polydev").setup({
  terminal = {
    border = true,
  },
})
```
---
