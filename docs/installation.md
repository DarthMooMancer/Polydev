## **Lazy.nvim**

```lua
return {
    "DarthMooMancer/Polydev",
    dependencies = {
        "MunifTanjim/nui.nvim"
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
        "MunifTanjim/nui.nvim"
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
        "MunifTanjim/nui.nvim"
    },
})

require("Polydev").setup({})
```

---
