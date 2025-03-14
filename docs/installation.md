# Installation
!!! Polydev can be installed with any plugin installer or manually. These are just examples.

## Lazyvim
----------

```lua
require {
  "DarthMooMancer/Polydev",
  config = function()
    require("Polydev").setup()
    --require("Polydev").language.setup({
        -- configs
      })
  end
}
```

## Mini.Deps
------------
```lua
MiniDeps.add({
  source = 'DarthMooMancer/Polydev',
})

require("Polydev").setup()
require("Polydev").language.setup({
  -- configs
})
```
