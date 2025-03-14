local M = {}
M.close_key = nil
M.lua_run = nil
M.new_lua_file = nil

M.config = {
    project_root = "~/Projects/Lua",  -- Modify this path as needed
    keybinds = {
        ["<Esc>"] = "CloseTerminal",
        ["<leader>pr"] = "LuaRun",
        ["<leader>nf"] = "NewLuaFile",
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

-- Function to get the project root directory
function M.get_project_root()
    -- Find the .polydev file in the current directory or any parent directories
    local current_dir = M.get_project_root()  -- Get current file's directory

    -- Search upwards for the .polydev file
    local polydev_file = vim.fn.findfile(".polydev", current_dir .. ";")
    if polydev_file == "" then
        print("Error: .polydev file not found in the current or parent directories.")
        return nil
    end

    -- Extract the name of the project from the .polydev file (excluding the extension)
    local project_name = polydev_file:match("([^/]+)%.polydev$")
    if not project_name then
        print("Error: Unable to extract project name from .polydev file.")
        return nil
    end

    -- Construct the project root path based on the project name
    local project_root = vim.fn.expand(M.config.project_root) .. "/" .. project_name
    return project_root
end

-- Function to setup the configuration
function M.setup(opts)
    M.config = vim.tbl_deep_extend("force", M.config, opts or {})
    for key, command in pairs(M.config.keybinds) do
        if command == "CloseTerminal" then M.close_key = key end
        if command == "LuaRun" then M.lua_run = key end
        if command == "NewLuaFile" then M.new_lua_file = key end
    end

    -- Define user commands and key mappings
    vim.api.nvim_create_user_command("NewLuaFile", M.create_new_file, {})
    vim.api.nvim_create_user_command("LuaRun", M.run, {})

    vim.keymap.set("n", M.lua_run, ":LuaRun<CR>", { silent = true })
    vim.keymap.set("n", M.new_lua_file, ":NewLuaFile<CR>", { silent = true })
end

-- Function to open a floating terminal with command
function M.open_float_terminal(cmd)
    local ui = vim.api.nvim_list_uis()[1]
    local term_cfg = M.config.terminal

    local width = math.max(1, math.floor(ui.width * 0.9) - term_cfg.left_padding - term_cfg.right_padding)
    local height = math.max(1, math.floor(ui.height * 0.9) - term_cfg.top_padding - (term_cfg.bottom_padding + 1))
    local row = math.max(1, math.floor((ui.height - height) / 2) + term_cfg.top_padding)
    local col = math.max(1, math.floor((ui.width - width) / 2) + term_cfg.left_padding)

    local buf = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = term_cfg.border and "rounded" or "none",
    })

    vim.api.nvim_win_set_option(win, "winblend", vim.o.pumblend)
    vim.api.nvim_win_set_option(win, "winhighlight", "Normal:Pmenu,FloatBorder:Pmenu")
    vim.api.nvim_win_set_option(win, "cursorline", true)
    if term_cfg.number then
        vim.api.nvim_win_set_option(win, "number", true)
        if term_cfg.relativenumber then
            vim.api.nvim_win_set_option(win, "relativenumber", true)
        end
    end
    if term_cfg.scroll then
        vim.api.nvim_win_set_option(win, "scrolloff", 5)
    end

    vim.fn.termopen(cmd)
    vim.api.nvim_buf_set_keymap(buf, "n", M.close_key, "i<C-\\><C-n>:q<CR>", { noremap = true, silent = true })
    return buf, win
end

-- Function to write content to a file
local function write_file(path, content)
    local file = assert(io.open(path, "w"), "Error creating file: " .. path)
    file:write(content)
    file:close()
    vim.cmd("edit " .. path)
    print(path .. " created successfully!")
end

-- Function to create a new project with the required directories
function M.create_project()
    vim.ui.input({ prompt = "Enter project name: " }, function(project_name)
        if not project_name or project_name == "" then
            print("Project creation canceled.")
            return
        end

        local project_root = vim.fn.expand(M.config.project_root) .. "/" .. project_name
        -- Create the required directory structure
        for _, path in ipairs({ "/lua/" .. project_name }) do
            vim.fn.mkdir(project_root .. path, "p")
        end

        -- Create a sample init.lua
        write_file(project_root .. "/lua/" .. project_name .. "/init.lua", [[
local M = {}
return M
]])

        -- Create a .polydev file using the project name
        write_file(project_root .. "/" .. project_name .. ".polydev", [[
-- Lua polydev file for project ]] .. project_name .. [[
-- This file will be used to execute your project

local example = require("]] .. project_name .. [[.example")
-- Example of running the project
example.run()
]])

        vim.cmd("edit " .. project_root .. "/lua/" .. project_name .. "/init.lua")
    end)
end

-- Function to create a new Lua file
function M.create_new_file()
    vim.ui.input({ prompt = "Enter file name: " }, function(class_name)
        if not class_name or class_name == "" then return print("File creation canceled.") end
        local root_dir = M.get_project_root()
        if not root_dir then return print("Error: Project root not found.") end
        write_file(root_dir .. "/lua/" .. M.get_project_name() .. "/" .. class_name .. ".lua", "")
    end)
end

-- Function to run the project by using the <name>/lua/<name>/init.lua file
function M.run()
    local root = M.get_project_root()
    if not root then return print("Error: Project root not found.") end
    
    -- Define the path to the <project_name>/lua/<project_name>/init.lua file
    local project_name = M.get_project_name()
    local init_lua_path = root .. "/lua/" .. project_name .. "/init.lua"
    
    -- Check if the init.lua file exists
    if vim.fn.filereadable(init_lua_path) == 1 then
        M.open_float_terminal("lua " .. init_lua_path)
    else
        print("Error: " .. init_lua_path .. " not found in " .. root)
    end
end

return M

