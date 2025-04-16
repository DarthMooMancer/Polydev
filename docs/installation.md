# Installation
!!! Polydev can be installed with any plugin installer or manually. These are just examples.

* Side note: A lot of the languages require a <project_name>.polydev file. If you dont have it in a language that needs it, it will error out and yell at you.

## Lazyvim
----------

```lua
return {
    "DarthMooMancer/Polydev",
    opts = {
        <language> = {
            ...
        },
        terminal = {
            ...
        }
    }
}
```

## Mini.Deps
------------

```lua
MiniDeps.add({
    source = 'DarthMooMancer/Polydev',
})

require("Polydev").setup({
    <language> = {
        ...
    },
    terminal = {
        ...
    }
})
```
