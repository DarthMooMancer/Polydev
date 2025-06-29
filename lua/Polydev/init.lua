local M = {}

function M.setup(opts)
    opts = opts or {}
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
	    local function define(name, o)
		if vim.fn.hlexists(name) == 0 then
		    vim.api.nvim_set_hl(0, name, o)
		end
	    end

	    define("PolydevNormal", {
		fg = vim.api.nvim_get_hl(0, { name = "NormalFloat", link = true }).fg,
		bg = vim.api.nvim_get_hl(0, { name = "Normal", link = true }).bg,
	    })

	    define("PolydevBorder", {
		fg = vim.api.nvim_get_hl(0, { name = "FloatBorder", link = true }).fg,
		bg = vim.api.nvim_get_hl(0, { name = "Normal", link = true }).bg,
	    })

	    define("PolydevTitle",  {
		fg = vim.api.nvim_get_hl(0, { name = "FloatTitle", link = true }).fg, bold = true,
		bg = vim.api.nvim_get_hl(0, { name = "Normal", link = true }).bg,
	    })
	end,
    })
end

return M
