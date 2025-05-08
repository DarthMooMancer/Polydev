# **Installation**

Polydev can be installed using any plugin manager of your choice — or even manually. Below are some examples for popular managers to get you started.

> ⚠️ **Disclaimer**: The `opts` and configuration values shown below are simply examples. You can customize them based on your preferences or even omit them entirely if not needed.

> **Note: Requires Neovim 0.10+**

---

## **Lazy.nvim**

```lua
return {
    "DarthMooMancer/Polydev",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim"
    },
    opts = {}, -- Setup is later on for configs
}
```

---

## **Mini.deps**

```lua
MiniDeps.add({
    source = "DarthMooMancer/Polydev"
    depends = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim"
    }
})

require("Polydev").setup({})
```

---

## **Packer.nvim**

```lua
use({
    "DarthMooMancer/Polydev",
    requires = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim"
    },
})

require("Polydev").setup({})
```

---
