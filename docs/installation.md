# 📦 Installation

Polydev can be installed using any plugin manager of your choice—or even manually. Below are some examples for popular managers to get you started.

> ⚠️ **Disclaimer**: The `opts` and configuration values shown below are simply examples. You can customize them based on your preferences or even omit them entirely if not needed.

> 💡 **Heads up!** Many language presets in Polydev require a file named `<project_name>.polydev` in your project root. If it's missing, Polydev will let you know (loudly 😅).

> **Note**: Languages that require to build just need to be run, building is builtin to the run command

---

## 🛌 Lazy.nvim

> This is the **recommended** way if you're using [Lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
return {
    "DarthMooMancer/Polydev",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim"
    },
    opts = { -- Below are just example values
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

---

## 🧸 Mini.deps

For users of [mini.nvim](https://github.com/echasnovski/mini.nvim)'s dependency manager:

```lua
MiniDeps.add({
    source = "DarthMooMancer/Polydev"
    depends = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim"
    }
})

require("Polydev").setup({
    rust = {
        project_root = "~/Projects/Rust",
        keybinds = {
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
    requires = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim"
    },
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
Plug 'MunifTanjim/nui.nvim'
Plug 'nvim-lua/plenary.nvim'

lua << EOF
require("Polydev").setup({
    c = {
        project_root = "~/Projects/C",
        keybinds = {
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
