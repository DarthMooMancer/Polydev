local M = {}

function M.setup(opts)
    local config = require("Polydev.configs")
    config.setup(opts)
    require("Polydev.utils").setup(opts)

    vim.api.nvim_create_user_command("PolydevOpen", function() require("Polydev.ui").manager(config.get("globals").project_root) end, {})

    local keys = vim.tbl_deep_extend("force", {}, config.get("globals").keybinds, opts.keybinds or {})
    for key, _ in pairs(keys) do
	vim.keymap.set("n", key, ":PolydevOpen<CR>")
    end

    vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
	    local filetype = vim.bo.filetype
	    require("Polydev.languages").load_language_module(filetype, opts)
	end,
    })
    vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
	    require("Polydev.styles").setup_highlights()
	end,
    })
end

return M
