---@module "Polydev.configs"
local config = require("Polydev.configs")

---@module "Polydev.utils"
local utils = require("Polydev.utils")

---@module "Polydev.templates"
local templates = require("Polydev.templates")

---@type table
local M = {}

---@type table
M.loaded_languages = {}

---@param lang string
---@param opts table?
---@return boolean
function M.load_language_module(lang, opts)
    if M.loaded_languages[lang] then return true end

    local ok, lang_module = pcall(require, "Polydev.languages." .. lang)
    if ok and lang_module.setup then
        local lang_opts = opts and opts[lang] or {}
        lang_module.setup(lang_opts)
        M.loaded_languages[lang] = lang_module
        return true
    end
    return false
end

function M.create_project()
    local opts = {}
    vim.ui.input({ prompt = "Enter language for project: " }, function(lang)
	if not lang or lang == "" then return print("Project creation canceled.") end
	opts = vim.tbl_deep_extend("force", {}, config.get(lang), opts or {})
	if M.load_language_module(lang) and templates.projects[lang] and templates.projects[lang].run then
	    templates.create_project(lang, opts.project_root)
	else
	    print("Error: No project creation method for " .. lang)
	end
    end)
end

function M.create_new_file()
    vim.ui.input({ prompt = "Enter language for new file: " }, function(lang)
	if not lang or lang == "" then return print("File creation canceled.") end

	if M.load_language_module(lang) and templates.files[lang] and templates.files[lang].run then
	    templates.create_new_file(lang)
	else
	    print("Error: No File creation method for " .. lang)
	end
    end)
end

---@param opts table
function M.setup(opts)
    opts = opts or {}
    config.setup(opts)
    utils.setup(opts)
    for lang, user_opts in pairs(opts) do
	local default = config.defaults[lang] or {}
	config.user_config[lang] = vim.tbl_deep_extend("force", default, user_opts)
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

---@return table
return M
