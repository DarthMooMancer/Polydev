local M = {}
local utils = require("Polydev.utils")

M.lua_run = nil
M.config = {
    project_root = "~/Projects/Lua",
    keybinds = {
        ["<leader>pr"] = "LuaRun",
    },
}

function M.get_project_root()
    local dir = vim.fn.expand("%:p:h")
    while dir ~= "/" do
        local polydev_file = vim.fn.glob(dir .. "/*.polydev")
        if polydev_file ~= "" then return dir end
        dir = vim.fn.fnamemodify(dir, ":h")
    end
    return nil
end

function M.get_project_name()
    local root = M.get_project_root()
    if not root then return nil end
    local polydev_file = vim.fn.glob(root .. "/*.polydev")
    return polydev_file:match("([^/]+)%.polydev$")
end

function M.setup(opts)
    M.config = vim.tbl_deep_extend("force", M.config, opts or {})
    for key, command in pairs(M.config.keybinds) do
        if command == "LuaRun" then M.lua_run = key end
    end

    vim.api.nvim_create_user_command("LuaRun", M.run, {})
    vim.keymap.set("n", M.lua_run, ":LuaRun<CR>", { silent = true })
end

function M.create_project()
    vim.ui.input({ prompt = "Enter project name: " }, function(project_name)
        if not project_name or project_name == "" then return print("Project creation canceled.") end
        local project_root = vim.fn.expand(M.config.project_root) .. "/" .. project_name
        for _, path in ipairs({ "/lua/" .. project_name }) do vim.fn.mkdir(project_root .. path, "p") end

        utils.write_file(project_root .. "/lua/" .. project_name .. "/init.lua", [[
local M = {}

return M
]])

        utils.write_file(project_root .. "/" .. project_name .. ".polydev", "[[DO NOT REMOVE THIS FILE]]")
        vim.cmd("edit " .. project_root .. "/lua/" .. project_name .. "/init.lua")
    end)
end

function M.create_new_file()
    vim.ui.input({ prompt = "Enter file name: " }, function(class_name)
        if not class_name or class_name == "" then return print("File creation canceled.") end
        local root_dir = M.get_project_root()
        local project_name = M.get_project_name()
        if not root_dir or not project_name then return print("Error: Project root not found.") end
        utils.write_file(root_dir .. "/lua/" .. project_name .. "/" .. class_name .. ".lua", "")
    end)
end

function M.run()
    local root = M.get_project_root()
    local project_name = M.get_project_name()
    if not root or not project_name then return print("Error: Project root not found.") end
    local init_lua_path = root .. "/lua/" .. project_name .. "/init.lua"
    if vim.fn.filereadable(init_lua_path) == 1 then
        utils.open_float_terminal("lua " .. init_lua_path)
    else
        print("Error: " .. init_lua_path .. " not found in " .. root)
    end
end

return M

