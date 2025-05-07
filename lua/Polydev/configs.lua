local M = {}

M.defaults = {
    globals = {
	keybinds = {
	    ["<leader>po"] = "PolydevManager",
	}
    },
    html = {
	project_root = "~/Projects/Html",
    },
    rust = {
	project_root = "~/Projects/Rust",
	keybinds = {
	    ["<leader>pb"] = "RustBuild",
	    ["<leader>pr"] = "RustRun",
	},
    },
    java = {
	project_root = "~/Projects/Java",
	keybinds = {
	    ["<leader>pb"] = "JavaBuild",
	    ["<leader>pr"] = "JavaRun",
	},
    },
    python = {
	project_root = "~/Projects/Python",
	keybinds = {
	    ["<leader>pr"] = "PythonRun",
	    ["<leader>pb"] = "PythonPip",
	},
    },
    lua = {
	project_root = "~/Projects/Lua",
	keybinds = {
	    ["<leader>pr"] = "LuaRun",
	},
    },
    c = {
	project_root = "~/Projects/C",
	keybinds = {
	    ["<leader>pb"] = "CBuild",
	    ["<leader>pr"] = "CRun",
	    ["<leader>nh"] = "NewCHeaderFile",
	},
	build_attributes = ""
    },
    cpp = {
	project_root = "~/Projects/Cpp",
	keybinds = {
	    ["<leader>pb"] = "CppBuild",
	    ["<leader>pr"] = "CppRun",
	    ["<leader>nh"] = "NewCppHeaderFile",
	},
	build_attributes = "",
    },
    terminal = {
	presets = "centered",
	border = true,
	number = true,
	relativenumber = true,
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
