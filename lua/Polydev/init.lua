local M = {}

M.loaded_languages = {}
M.java = require("Polydev.java")
M.c = require("Polydev.c")

-- Load language module dynamically
function M.load_language_module(lang)
    if M.loaded_languages[lang] then return true end -- Prevent redundant loading

    local ok, lang_module = pcall(require, "Polydev." .. lang)
    if ok and lang_module.setup then
	lang_module.setup()
	M.loaded_languages[lang] = lang_module
	return true
    end

    print("Error: Unsupported language '" .. lang .. "'")
    return false
end

-- Create a new project by specifying a language
function M.create_project()
    vim.ui.input({ prompt = "Enter language for project: " }, function(lang)
	if not lang or lang == "" then return print("Project creation canceled.") end

	if M.load_language_module(lang) and M.loaded_languages[lang].create_project then
	    M.loaded_languages[lang].create_project()
	else
	    print("Error: No project creation method for " .. lang)
	end
    end)
end

-- Auto-load language module based on file type
function M.setup()
    vim.api.nvim_create_user_command("NewProject", M.create_project, {})
    vim.keymap.set("n", "<leader>np", ":NewProject<CR>", { silent = true })
    vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
	    local filetype = vim.bo.filetype
	    M.load_language_module(filetype)
	end,
    })
end

return M

