local M = {}

M.defaults = {
    python = {
	project_root = "~/Projects/Python",
	keybinds = {
	    ["<leader>pr"] = "PythonRun",
	    ["<leader>pb"] = "PythonPip",
	    ["<leader>pc"] = "PythonCustom"
	},
    },
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

M.user_config = {}

function M.setup(user_opts)
    M.user_config = vim.tbl_deep_extend("force", {}, M.defaults, user_opts or {})
end

function M.get(lang)
    return M.user_config[lang] or {}
end

return M
