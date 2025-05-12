local utils = require("Polydev.utils")
local M = {}

M.keybinds = {}
M.opts = {}

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
    local init_lua_path = utils.get_project_root() .. "/lua/" .. utils.get_project_name() .. "/init.lua"
    if vim.fn.filereadable(init_lua_path) == 1 then
        utils.open_float_terminal("lua " .. init_lua_path)
    end
end

return M
