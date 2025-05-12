local utils = require("Polydev.utils")
local M = {}

function M.setup(user_opts)
    local opts = vim.tbl_deep_extend("force", {}, require("Polydev.configs").get("lua"), user_opts or {})
    vim.api.nvim_create_user_command("LuaRun", M.run, {})
    for key, _ in pairs(opts.keybinds) do
	vim.keymap.set("n", key, ":LuaRun<CR>", { silent = true })
    end
end

function M.run()
    local init_lua_path = utils.get_project_root() .. "/lua/" .. utils.get_project_name() .. "/init.lua"
    if vim.fn.filereadable(init_lua_path) == 1 then
        utils.open_float_terminal({ "lua " .. init_lua_path })
    end
end

return M
