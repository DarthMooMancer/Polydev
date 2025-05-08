local M = {}

local loaded_languages = {}
local function load_language_module(lang, opts)
    if loaded_languages[lang] then return true end

    local ok, mod = pcall(require, "Polydev.languages." .. lang)
    if not ok or type(mod.setup) ~= "function" then return false end

    mod.setup(opts and opts[lang] or {})
    loaded_languages[lang] = mod
    return true
end

function M.setup(opts)
    local opts = opts or {}
    local config = require("Polydev.configs")
    config.setup(opts)
    require("Polydev.utils").setup(opts)
    for lang, user_opts in pairs(opts) do
	local default = config.defaults[lang] or {}
	config.user_config[lang] = vim.tbl_deep_extend("force", default, user_opts)
    end

    vim.api.nvim_create_user_command("PolydevOpen", require("Polydev.ui").open_project_manager, {})

    local keys = vim.tbl_deep_extend("force", {}, config.get("globals").keybinds, opts or {})
    for key, command in pairs(keys) do
	vim.keymap.set("n", key, ":PolydevOpen<CR>", { silent = true })
	break
    end

    vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
	    local filetype = vim.bo.filetype
	    load_language_module(filetype, opts)
	end,
    })
end

return M
