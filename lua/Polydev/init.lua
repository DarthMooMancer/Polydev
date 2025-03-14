local M = {}

-- Store loaded language modules
M.loaded_languages = {}

-- Function to load the appropriate language module
function M.load_language_module()
    local filetype = vim.bo.filetype
    if M.loaded_languages[filetype] then return end -- Prevent redundant loading

    local ok, lang_module = pcall(require, "Polydev." .. filetype)
    if ok and lang_module.setup then
        lang_module.setup()
        M.loaded_languages[filetype] = true
    end
end

-- Setup function to initialize the plugin
function M.setup()
    -- Auto-load the correct module when opening a file
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function()
            M.load_language_module()
        end,
    })
end

return M
