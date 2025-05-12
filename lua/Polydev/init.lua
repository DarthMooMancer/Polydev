local M = {}

function M.setup(opts)
    local config = require("Polydev.configs")
    local ui = require("Polydev.ui")
    config.setup(opts)
    require("Polydev.utils").setup(opts)
    for lang, user_opts in pairs(opts) do
	config.user_config[lang] = vim.tbl_deep_extend("force", config.defaults[lang] or {}, user_opts)
    end

    vim.api.nvim_create_user_command("PolydevOpen", ui.manager, {})

    local keys = vim.tbl_deep_extend("force", {}, config.get("globals").keybinds, opts or {})
    for key, _ in pairs(keys) do
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
