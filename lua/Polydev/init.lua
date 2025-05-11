local M = {}

function M.setup(opts)
    local opts = opts or {}
    local config = require("Polydev.configs")
    local ui = require("Polydev.ui")
    config.setup(opts)
    require("Polydev.utils").setup(opts)
    for lang, user_opts in pairs(opts) do
	local default = config.defaults[lang] or {}
	config.user_config[lang] = vim.tbl_deep_extend("force", default, user_opts)
    end

    vim.api.nvim_create_user_command("PolydevOpen", ui.open_project_manager, {})

    local keys = vim.tbl_deep_extend("force", {}, config.get("globals").keybinds, opts or {})
    for key, command in pairs(keys) do
	vim.keymap.set("n", key, ":PolydevOpen<CR>", { silent = true })
	break
    end

    vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
	    local filetype = vim.bo.filetype
	    ui.load_language_module(filetype, opts)
	end,
    })
end

return M
