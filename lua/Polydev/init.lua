local M = {}

M.loaded_languages = {}
M.globals = require("Polydev.globals")
M.java = require("Polydev.java")
M.c = require("Polydev.c")
M.cpp = require("Polydev.cpp")
M.lua = require("Polydev.lua")
M.python = require("Polydev.python")
M.rust = require("Polydev.rust")
M.html = require("Polydev.html")

function M.load_language_module(lang, opts)
    if M.loaded_languages[lang] then return true end

    local ok, lang_module = pcall(require, "Polydev." .. lang)
    if ok and lang_module.setup then
        local lang_opts = opts and opts[lang] or {}
        lang_module.setup(lang_opts)
        M.loaded_languages[lang] = lang_module
        return true
    end
    return false
end

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

function M.create_new_file()
    vim.ui.input({ prompt = "Enter language for new file: " }, function(lang)
	if not lang or lang == "" then return print("File creation canceled.") end

	if M.load_language_module(lang) and M.loaded_languages[lang].create_new_file then
	    M.loaded_languages[lang].create_new_file()
	else
	    print("Error: No File creation method for " .. lang)
	end
    end)
end

function M.setup(opts)
    opts = opts or {}

    -- Merge globals if provided
    if opts.globals then
        M.globals.config = vim.tbl_deep_extend("force", M.globals.config, opts.globals)
    end

    vim.api.nvim_create_user_command("NewProject", M.create_project, {})
    vim.api.nvim_create_user_command("NewFile", M.create_new_file, {})
    vim.keymap.set("n", "<leader>np", ":NewProject<CR>", { silent = true })
    vim.keymap.set("n", "<leader>nf", ":NewFile<CR>", { silent = true })
    vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
	    local filetype = vim.bo.filetype
	    M.load_language_module(filetype, opts)
	end,
    })
end

return M
