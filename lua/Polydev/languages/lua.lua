---@module "Polydev.utils"
local utils = require("Polydev.utils")

---@type table
local M = {}

---@type table
M.keybinds = {}

---@type table|nil
M.opts = nil

---@param opts table
function M.setup(opts)
    M.opts = vim.tbl_deep_extend("force", {}, require("Polydev.configs").get("lua"), opts or {})
    for key, command in pairs(M.opts.keybinds) do
	M.keybinds[command] = key
    end

    vim.api.nvim_create_user_command("LuaRun", M.run, {})

    if M.keybinds.LuaRun then
	vim.keymap.set("n", M.keybinds.LuaRun, ":LuaRun<CR>", { silent = true })
    end
end

function M.run()
    ---@return string|nil
    local function get_project_root()
	local dir = vim.fn.expand("%:p:h")
	while dir ~= "/" do
	    local polydev_file = vim.fn.glob(dir .. "/*.polydev")
	    if polydev_file ~= "" then return dir end
	    dir = vim.fn.fnamemodify(dir, ":h")
	end
	return nil
    end

    ---@return string
    local function get_project_name()
	return vim.fn.glob((get_project_root() or "") .. "/*.polydev"):match("([^/]+)%.polydev$")
    end

    ---@return string
    if not get_project_root() or not get_project_name() then return print("Error: Project root not found.") end
    local init_lua_path = get_project_root() .. "/lua/" .. get_project_name() .. "/init.lua"
    if vim.fn.filereadable(init_lua_path) == 1 then
        utils.open_float_terminal("lua " .. init_lua_path)
    else
        print("Error: " .. init_lua_path .. " not found in " .. get_project_root())
    end
end

---@return table
return M
