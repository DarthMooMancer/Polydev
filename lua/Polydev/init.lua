local M = {}

M.language_configs = {}

-- Load language module and apply its config
function M.load_language_module(lang)
    local lang_module = require("Polydev." .. lang)
    if lang_module then
        lang_module.setup()
        M.language_configs[lang] = lang_module.config or {}  -- Store the configuration
        return true
    end
    return false
end

-- Apply the configuration for the specified language
function M.apply_language_config(lang)
    local config = M.language_configs[lang]
    if not config then return end

    -- Apply keybindings and terminal settings
    for key, command in pairs(config.keybinds or {}) do
        vim.keymap.set("n", key, ":" .. command .. "<CR>", { silent = true })
    end

    if config.project_root then vim.env.PROJECT_ROOT = config.project_root end
    if config.terminal then M.apply_terminal_config(config.terminal) end
end

-- Apply terminal-specific settings
function M.apply_terminal_config(terminal_config)
    vim.o.termguicolors = true
    if terminal_config.number ~= nil then vim.o.number = terminal_config.number end
    if terminal_config.relativenumber ~= nil then vim.o.relativenumber = terminal_config.relativenumber end
    if terminal_config.scroll ~= nil then vim.o.scrolloff = terminal_config.scroll and 5 or 0 end
end

-- Create a new project by specifying a language
function M.create_project()
    vim.ui.input({ prompt = "Enter language for project: " }, function(lang)
        if lang and M.load_language_module(lang) then
            local lang_module = M.language_configs[lang]
            if lang_module.create_project then
                lang_module.create_project()
            else
                print("Error: No project creation method for " .. lang)
            end
        else
            print("Project creation canceled or unsupported language.")
        end
    end)
end

-- Set up the plugin, including user commands and auto-detection
function M.setup()
    vim.api.nvim_create_user_command("NewProject", M.create_project, {})
    vim.keymap.set("n", "<leader>np", ":NewProject<CR>", { silent = true })
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function()
            M.load_language_module(vim.bo.filetype)
            M.apply_language_config(vim.bo.filetype)
        end,
    })
end

return M
