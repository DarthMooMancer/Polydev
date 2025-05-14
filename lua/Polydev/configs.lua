local M = {}

M.defaults = {
    globals = {
	project_root = "~/Projects",
	keybinds = {
	    ["<leader>po"] = "PolydevManager",
	}
    },
    terminal = {
	preset = "max",
	border = true,
    }
}

M.defaults.rust = {
    project_root = M.defaults.globals.project_root .. "/Rust",
    keybinds = {
	["<leader>pr"] = "RustRun",
    },
}

M.defaults.java = {
    project_root = M.defaults.globals.project_root .. "/Java",
    keybinds = {
	["<leader>pr"] = "JavaRun",
    },
}

M.defaults.python = {
    project_root = M.defaults.globals.project_root .. "/Python",
    keybinds = {
	["<leader>pr"] = "PythonRun",
	["<leader>pb"] = "PythonPip",
    },
}

M.defaults.lua = {
    project_root = M.defaults.globals.project_root .. "/Lua",
    keybinds = {
	["<leader>pr"] = "LuaRun",
    },
}

M.defaults.c = {
    project_root = M.defaults.globals.project_root .. "/C",
    keybinds = {
	["<leader>pr"] = "CRun",
    },
    build_attributes = "",
}

M.defaults.cpp = {
    project_root = M.defaults.globals.project_root .. "/CPP",
    keybinds = {
	["<leader>pr"] = "CppRun",
    },
    build_attributes = "",
}

M.defaults.html = {
    project_root = M.defaults.globals.project_root .. "/Html",
}

M.user_config = {}

function M.setup(user_opts)
    M.user_config = vim.tbl_deep_extend("force", {}, M.defaults, user_opts or {})
end

function M.get(lang)
    return M.user_config[lang] or {}
end

return M
