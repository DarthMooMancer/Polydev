![banner-2](https://github.com/user-attachments/assets/c9e52b54-c7ad-414d-a282-89398e58a71a)

## Why?
-------

The main goal is the plugin is to be simple and extensible for Java developers. Are there better plugins? Most likely, however this has simple functions for:

- Creating New Projects
- Creating New Files (With Class Generation)
- Building Files (Currently only Main.java files)
- Running Files (Again only Main.java files)

## Installation

For Lazy.nvim:
```
require {
  "DarthMooMancer/nvim-java",
  config = function()
    require("nvim-java").setup()
  end
}

```

For Mini.Deps:
```
MiniDeps.add({ source = 'DarthMooMancer/nvim-java', name = "nvim-java" })
require("nvim-java").setup()

```

!!! You can install with any plugin manager, these are just examples. You can try this with vim, but I cant guarantee that it would work. !!!

## Config
Currently the only thing you can change is the project root, here is how:
```
require...({
    project_root = "Your folder or directory"
})
```
- Can use whatever for example: "~/whatever"
- It will automatically make the new Root Directory, so you don't have to worry about that.
- If you want the keybinds to be included as default and able to be changed, you can request it. I dont see the need right now however.

## Keybinds

Nvim-java doesnt come with default keybinds; however, here are the ones I use and recommend:

```
vim.keymap.set("n", "<leader>jb", ":JavaBuild<CR>", { silent = true })
vim.keymap.set("n", "<leader>jr", ":JavaRun<CR>", { silent = true })
vim.keymap.set("n", "<leader>nf", ":NewJavaFile<CR>", { silent = true })
vim.keymap.set("n", "<leader>np", ":NewJavaProject<CR>", { silent = true })
```

## Questions and Contributing

If you want to contribute, make a PR or issue and I will answer as soon as I see it. 

!!! I suck at lua, and would like some help if you are able to contribute. If all else fails I will use Ai to help me add features and/or fix features. Help me from using it and make my learning of lua and life easier. !!!

If you have questions, just ask in issues or discussions and I will answer them.
