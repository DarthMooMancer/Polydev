local M = {}

M.language_configs = {}

-- Load language module and apply its config
function M.load_language_module(lang)
    -- Check if the language module is already loaded
    if M.loaded_languages[lang] then return true end

    -- Only attempt to load if it's a valid language (exclude non-programming filetypes)
    local valid_languages = { "java", "c", "python", "go", "rust" }  -- Add more languages as needed
    local is_valid = false
    for _, valid_lang in ipairs(valid_languages) do
        if lang == valid_lang then
            is_valid = true
            break
        end
    end

    -- If it's a valid language, attempt to load the module
    if is_valid then
        local ok, lang_module = pcall(require, "Polydev." .. lang)
        if ok and lang_module.setup then
            lang_module.setup()
            M.loaded_languages[lang] = lang_module
            return true
        end
    end

    -- If not a valid language or module not found, suppress the error
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
