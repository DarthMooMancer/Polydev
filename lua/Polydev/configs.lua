---@type table
local M = {}

---@class KeybindConfigs
---@field [string] string
---
---@class LanguageConfigs
---@field project_root? string
---@field keybinds? KeybindConfigs -- ? makes fields optional
---@field build_attributes? string
---
---@class TerminalConfigs
---@field right_padding integer
---@field left_padding integer
---@field bottom_padding integer
---@field top_padding integer
---@field border boolean
---@field number boolean
---@field relativenumber boolean
---
---@class Defaults
---@field html LanguageConfigs
---@field rust LanguageConfigs
---@field java LanguageConfigs
---@field python LanguageConfigs
---@field lua LanguageConfigs
---@field c LanguageConfigs
---@field cpp LanguageConfigs
---@field terminal TerminalConfigs

---@type Defaults
M.defaults = {
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
	right_padding = 0,
	bottom_padding = 0,
	left_padding = 0,
	top_padding = 0,
	border = true,
	number = true,
	relativenumber = true,
    }
}

---@type string[]
M.user_config = {}

---@param user_opts table
function M.setup(user_opts)
    M.user_config = vim.tbl_deep_extend("force", {}, M.defaults, user_opts or {})
end

---@param lang string
---@return string|table
function M.get(lang)
    return M.user_config[lang] or {}
end

---@return table
return M
