# Installation
!!! Polydev can be installed with any plugin installer or manually. These are just examples.

## Lazyvim
----------

```lua
require {
  "DarthMooMancer/Polydev",
  config = function()
    require("Polydev").language.setup()
  end
}
```

## Mini.Deps
------------
```lua
MiniDeps.add({
  source = 'DarthMooMancer/Polydev',
})

require("Polydev").language.setup()
```
