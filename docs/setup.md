# Setup and Customizing

## Project Name
* You can change the default directory for the project. The project can be made from anywhere you want.
* It will automatically make the new Root Directory, so you don't have to worry about making it.

### Lazy
```lua
return {
    ...
    opts = {
        <language> = {
            project_root = "~/Home/..." -- Default: ~/Projects/Language

        }
    }
    ...
}
```

### Others
```lua
require("Polydev").language.setup({
    project_root = "~/Home/..." -- Default: ~/Projects/Language
})
```

## Keybinds
* Every language has the almost same keybinds so it is easy to remember keybinds and not have to remember thousands of keybinds.
* Some languages have separate functions (python has a pip keybind for example) adding more keybinds

Key/
├── *Universal, cannot be changed through specific language settings
└── *Per-language, can be changed separately by language if wanted

### Lazy
```lua
return {
    ...
    opts = {
        <language> = {
            ["<Esc>"] = "CloseTerminal", -- Planned to be *Universal -- However can be changed per language for now 
            ["<leader>pb"] = "languageBuild", -- *Per-language
            ["<leader>pr"] = "languageRun", -- *Per-language
            ["<leader>nf"] = "NewLanguageFile", --*Universal -- such as .c files
            ["<leader>nh"] = "NewLanguageSecondaryFile", --*Universal -- such as .h files
        }
    }
    ...
}
```

### Others
```lua
require("Polydev"}.language.setup({
    keybinds = [
        ["<Esc>"] = "CloseTerminal", -- Planned to be *Universal -- However can be changed per language for now 
        ["<leader>pb"] = "languageBuild", -- *Per-language
        ["<leader>pr"] = "languageRun", -- *Per-language
        ["<leader>nf"] = "NewLanguageFile", --*Universal -- such as .c files
        ["<leader>nh"] = "NewLanguageSecondaryFile", --*Universal -- such as .h files
}
})
```

## Terminal
!!! I plan on making the terminal settings a global setting instead of language specific, just need to figure out how
* The terminal has a couple of options that can be customized and with more to come
    - Each is set to 0 by default
        * **_right_padding:_** Padding for the right width of the terminal
        * **_left_padding:_** Padding for the left width of the terminal
        * **_top_padding:_** Padding for the top height of the terminal
        * **_bottom_padding:_** Padding for the bottom padding of the terminal
    - Each is enabled by default
        * **_border:_** Adds a rounded border to the window
        * **_number:_** Adds numbers to side of terminal
        * **_relativenumber:_** Relative numbers indicate distances from the cursor, only works if number is enabled
        * **_scroll:_** Allows scrolling in terminal

### Lazy
```lua
return {
    ...
    opts = {
        <language> = {
            terminal = {
                right_padding = 0,
                bottom_padding = 0,
                left_padding = 0,
                top_padding = 0,
                border = true,
                number = true,
                relativenumber = true,
                scroll = true,
            }
        }
    }
    ...
}
```

### Others

```lua
-- These are just defaults, so no need to copy them
require("Polydev").language.setup({
    terminal = {
        right_padding = 0,
        bottom_padding = 0,
        left_padding = 0,
        top_padding = 0,
        border = true,
        number = true,
        relativenumber = true,
        scroll = true,
    }
})
```
