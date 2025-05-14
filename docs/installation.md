# **Installation**

Polydev can be installed using any plugin manager of your choice — or even manually. Below are some examples for popular managers to get you started.

> **Requirement**: Neovim v0.10+

---

## **Lazy.nvim**

```lua
return {
    "DarthMooMancer/Polydev",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim"
    },
    opts = {}, -- Setup is later on
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
