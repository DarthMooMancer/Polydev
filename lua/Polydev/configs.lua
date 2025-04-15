local M = {}

M.config = {
    terminal = {
	right_padding = 0,
	bottom_padding = 0,
	left_padding = 0,
	top_padding = 0,
	border = true,
	number = true,
	relativenumber = true,
	scroll = true,
    }
}

function M.setup(opts)
    opts = opts or {}

    -- Make sure nested tables are deep-merged
    M.config.terminal = vim.tbl_deep_extend("force", M.config.terminal, opts.terminal or {})
end

return M
