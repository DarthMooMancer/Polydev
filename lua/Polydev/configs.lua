local M = {}

M.defaults = {
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
    -- java = { indent = 4 },
    -- python = { formatter = "black", linting = true },
    -- lua = { diagnostics = true },
    -- c = { compiler = "gcc" },
    -- cpp = { compiler = "g++" },
    -- rust = { edition = "2021" },
    -- html = { use_tailwind = false },
}

-- This will be updated by setup()
M.user_config = vim.deepcopy(M.defaults)

return M
