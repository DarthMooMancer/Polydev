# Setup and Customizing Polydev

## Project Manager
Follows the netrw keybinds and allows for project management all in one spot

## 🔧 Project Name Customization
You can easily customize the default directory for your project! The project can be created from any directory, and Polydev will automatically create the required project root directory for you.

> **Note:** `project_root` allows you to customize where your project will be stored. If you don't specify it, the default is `~/Projects/Language`.

---
### LazyVim Example

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

### Packer Example

```lua
require("Polydev").language.setup({
    project_root = "~/Home/..." -- Default: ~/Projects/Language
})
```

## ⌨ Keybinds Customization
Polydev allows you to easily manage keybinds, providing a uniform way to interact with different languages. Most keybinds are the same across languages, while some have language-specific ones (e.g., Python's pip keybind).

### Keybind Categories
| Keybind Type      | Description                                      |
|-------------------|--------------------------------------------------|
| **Universal**     | Cannot be changed through specific language settings (e.g., `<leader>nf` for a new file). |
| **Per-language**  | Can be customized per language (e.g., `<leader>pb` for language build). |

### LazyVim Example

```lua
return {
    ...
    opts = {
        <language> = {
            ["<leader>pb"] = "languageBuild",  -- Per-language
            ["<leader>pr"] = "languageRun",   -- Per-language
            ["<leader>nh"] = "NewLanguageSecondaryFile",  -- Universal
            ["<leader>po"] = "OpenSmartTable", -- Universal
        }
    }
    ...
}
```

### Packer Example

```lua
require("Polydev").language.setup({
    keybinds = {
        ["<leader>pb"] = "languageBuild",  -- Per-language
        ["<leader>pr"] = "languageRun",   -- Per-language
        ["<leader>nh"] = "NewLanguageSecondaryFile",  -- Universal
        ["<leader>po"] = "OpenSmartTable", -- Universal
    }
})
```

---

## 🖥 Terminal Customization
You can further tweak the terminal settings to suit your preferences! These options allow you to adjust padding, borders, numbers, and scrolling behavior.

### Available Terminal Settings
| Setting          | Default Value   | Description                                             |
|------------------|-----------------|---------------------------------------------------------|
| **presets**       | `centered`      | Presets for where the terminal is placed in the buffer  |
| **right_padding** | `0`             | Padding for the right width of the terminal.            |
| **left_padding**  | `0`             | Padding for the left width of the terminal.             |
| **top_padding**   | `0`             | Padding for the top height of the terminal.             |
| **bottom_padding**| `0`             | Padding for the bottom height of the terminal.          |
| **border**        | `true`          | Adds a rounded border to the window.                    |
| **number**        | `true`          | Displays line numbers in the terminal.                  |
| **relativenumber**| `true`          | Displays relative numbers based on cursor position.     |
| **scroll**        | `true`          | Enables scroll functionality in the terminal.           |

> **Note:** These terminal settings allow you to personalize the terminal view and improve usability. You can easily adjust the padding, borders, and other aspects to your preference.

### Available Presets
| Preset | Placement |
|--------|-----------|
| **center** | `completely centerd in the screen with a small amount of padding on each side of the buffer` |
| **right_panel** | `takes up about a third of the right side from top to bottom with a small amount of padding` |
| **center_panel** | `takes up about a third of the center from top to bottom with a small amount of padding` |
| **corner** | `takes up about a fourth of the bottom right corner with a small amount of padding` |

---
### LazyVim Example

```lua
return {
    ...
    opts = {
        terminal = {
            presets = "centered"
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
    ...
}
```

### Packer Example

```lua
require("Polydev").setup({
    terminal = {
        presets = "centered"
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

## 🚀 Final Thoughts and Customizations
This guide provided you with the basic configuration steps for setting up Polydev with your preferred package manager and customizing key aspects like project names, keybinds, and terminal settings.

You can further explore other Polydev features and modify the configuration to suit your development workflow.
