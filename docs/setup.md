# Setup and Customizing

## Project Name

### Without Lazy
```lua
require("Polydev").language.setup({
    project_root = "~/Home/..." -- Default: ~/Projects/Language
})
```

### With Lazy
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
* You can change the default directory for the project. The project can be made from anywhere you want.
* It will automatically make the new Root Directory, so you don't have to worry about making it.

## Keybinds
* Every language has the same keybinds so it is easy to remember keybinds and not have to remember thousands of keybinds.
* The only keybind that doesnt change no matter what happens is creating a new project. Enter the language you want, then enter the project name and boom! new project.
```lua
require("Polydev"}.language.setup({
    keybinds = [
        ["<Esc>"] = "CloseTerminal",
        ["<leader>pb"] = "languageBuild",
        ["<leader>pr"] = "languageRun",
        ["<leader>nf"] = "NewlanguageFile", -- such as .c files
        ["<leader>nh"] = "Newlanguage_secondaryFile", -- such as .h files
}
})
```

## Terminal
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
