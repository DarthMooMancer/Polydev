Nvim-Java
---------

Why?
------

The main goal is the plugin is to be simple and extensible for Java developers. Are there better plugins? Most likely, however this has simple functions for:

- Creating New Projects
- Creating New Files (With Class Generation)
- Building Files (Currently only Main.java files)
- Running Files (Again only Main.java files)

Installation
------------

For Lazy.nvim:
'''
require {
    "DarthMooMancer/nvim-java"
}
'''

For Mini.Deps:
'''
MiniDeps.add({ source = 'DarthMooMancer/nvim-java' })
'''

!!! You can install with any plugin manager, these are just examples. You can try this with vim, but I cant guarantee that it would work. !!!

Keybinds
--------

Nvim-java doesnt come with default keybinds; however, here are the ones I use and recommend:

'''
vim.keymap.set("n", "<leader>jb", ":JavaBuild<CR>", { silent = true })
vim.keymap.set("n", "<leader>jr", ":JavaRun<CR>", { silent = true })
vim.keymap.set("n", "<leader>nf", ":NewJavaFile<CR>", { silent = true })
vim.keymap.set("n", "<leader>np", ":NewJavaProject<CR>", { silent = true })
'''

Questions and Contributing
--------------------------

If you want to contribute, make a PR or issue and I will answer as soon as I see it. 

!!! I suck at lua, and would like some help if you are able to contribute. If all else fails I will use Ai to help me add features and/or fix features. Help me from using it and make my learning of lua and life easier. !!!

If you have questions, just ask in issues or discussions and I will answer them.
