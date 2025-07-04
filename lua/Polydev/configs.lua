local M = {}

---@param project_root string
---@return table
local function default_languages(project_root)
    return {
	rust = {
	    project_root = project_root .. "/Rust",
	    keybinds = {
		["<leader>pr"] = "RustRun",
	    },
	},
	java = {
	    project_root = project_root .. "/Java",
	    keybinds = {
		["<leader>pr"] = "JavaRun",
	    },
	},
	lua = {
	    project_root = project_root .. "/Lua",
	    keybinds = {
		["<leader>pr"] = "LuaRun",
	    },
	},
	c = {
	    project_root = project_root .. "/C",
	    keybinds = {
		["<leader>pr"] = "CRun",
	    },
	},
	cpp = {
	    project_root = project_root .. "/CPP",
	    keybinds = {
		["<leader>pr"] = "CppRun",
	    },
	},
	python = {
	    project_root = project_root .. "/Python",
	    keybinds = {
		["<leader>pr"] = "PythonRun",
		["<leader>pb"] = "PythonPip",
	    },
	},
	html = {
	    project_root = project_root .. "/Html",
	},
    }
end

M.user_config = {}

---@param user_opts table
function M.setup(user_opts)
    local defaults = {
	globals = {
	    project_root = "~/personal/Projects",
	    keybinds = {
		["<leader>po"] = "PolydevManager",
	    },
	},
	terminal = {
	    mode = "split",
	    win = {
		type = "horizontal", anchor = "bottom", size = "20"
	    },
	    border = {
		enabled = true,
		type = "rounded",
	    },
	},
    }

    M.user_config = vim.tbl_deep_extend("force", {}, defaults, user_opts or {})
    local langs = default_languages(M.user_config.globals.project_root)

    for lang, conf in pairs(langs) do
	M.user_config[lang] = vim.tbl_deep_extend("force", conf, M.user_config[lang] or {})
    end
end

---@param lang string
---@return table
function M.get(lang)
    return M.user_config[lang] or {}
end

return M
