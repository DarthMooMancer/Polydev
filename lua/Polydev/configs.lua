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
	    project_root = "~/Projects",
	    keybinds = {
		["<leader>po"] = "PolydevManager",
	    },
	},
	terminal = {
	    mode = "split", -- floating or split
	    win = {
		type = "vertical", anchor = "right" -- type: "vertical" or "horizonal" -- anchor: "below" or "right" or "center" or "corner"
	    },
	    border = {
		enabled = true,
		type = "rounded",
	    },
	},
    }

    -- First merge global and terminal
    M.user_config = vim.tbl_deep_extend("force", {}, defaults, user_opts or {})

    -- Now use the final resolved project_root from user_config
    local root = M.user_config.globals.project_root
    local langs = default_languages(root)

    -- Inject languages into the config, respecting user overrides
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
